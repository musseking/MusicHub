package com.music.hub.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;

import com.music.hub.service.SongService;
import com.music.hub.entity.Song;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;

@Controller
public class SongController {
    private final SongService songService;

    public SongController(SongService songService) {
        this.songService = songService;
    }

    // JAVNA RUTA - SVI MOGU DA VIDELISTU PESAMA
    @GetMapping("/songs")
    public String listSongs(Model model) {
        model.addAttribute("songs", songService.getAllSongs());
        model.addAttribute("title", "All Songs - MusicHub");
        return "songs";
    }

    // JAVNA RUTA - SVI MOGU DA VIDEDETALJE O PESMI
    @GetMapping("/songs/{id}")
    public String songDetails(@PathVariable Long id, Model model) {
        // Dohvati pesmu i dodaj je u model
        List<Song> allSongs = songService.getAllSongs();
        Song song = null;
        
        for (Song s : allSongs) {
            if (s.getId().equals(id)) {
                song = s;
                break;
            }
        }
        
        if (song != null) {
            model.addAttribute("song", song);
            model.addAttribute("title", song.getTitle() + " - MusicHub");
        } else {
            model.addAttribute("title", "Song Not Found - MusicHub");
        }
        
        return "song-details";
    }

    // NOVO: PREVIEW ENDPOINT - vraća samo prvih 60 sekundi pesme
    @GetMapping("/preview/{id}")
    @ResponseBody
    public ResponseEntity<Resource> songPreview(@PathVariable Long id) {
        System.out.println("🎵 PREVIEW ENDPOINT CALLED FOR SONG ID: " + id);
        
        try {
            // Dohvati pesmu
            List<Song> allSongs = songService.getAllSongs();
            Song song = null;
            
            for (Song s : allSongs) {
                if (s.getId().equals(id)) {
                    song = s;
                    break;
                }
            }
            
            if (song == null) {
                System.out.println("❌ PREVIEW ERROR: SONG NOT FOUND");
                return ResponseEntity.notFound().build();
            }
            
            System.out.println("✅ PREVIEW SONG: " + song.getTitle());
            
            // Pronađi fajl
            File audioFile = findAudioFile(song.getFilePath());
            
            if (audioFile == null || !audioFile.exists()) {
                System.out.println("❌ PREVIEW ERROR: FILE NOT FOUND");
                return ResponseEntity.notFound().build();
            }

            System.out.println("✅ PREVIEW FILE FOUND: " + audioFile.getAbsolutePath());
            
            // Za preview, uvek vraćamo samo prvih 60 sekundi
            Resource resource = new FileSystemResource(audioFile);
            
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, "audio/wav")
                    .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(audioFile.length()))
                    .header("X-Preview-Limit", "60") // Informacija za frontend
                    .body(resource);
                    
        } catch (Exception e) {
            System.out.println("❌ PREVIEW ERROR: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    // ZAŠTIĆENA RUTA - DOWNLOAD (samo logovani) - KORISTI @ResponseBody!
    @GetMapping("/download/{id}")
    @ResponseBody
    public ResponseEntity<Resource> downloadSong(@PathVariable Long id, Authentication authentication) {
        System.out.println("🎵🎵🎵 DOWNLOAD ENDPOINT HIT FOR SONG ID: " + id + " 🎵🎵🎵");
        
        // Provera autentifikacije
        if (authentication == null || !authentication.isAuthenticated()) {
            System.out.println("❌ DOWNLOAD DENIED: USER NOT AUTHENTICATED");
            return ResponseEntity.status(401).build();
        }

        try {
            // Dohvati pesmu
            List<Song> allSongs = songService.getAllSongs();
            Song song = null;
            
            for (Song s : allSongs) {
                if (s.getId().equals(id)) {
                    song = s;
                    break;
                }
            }
            
            if (song == null) {
                System.out.println("❌ DOWNLOAD ERROR: SONG NOT FOUND");
                return ResponseEntity.notFound().build();
            }
            
            System.out.println("✅ SONG FOUND: " + song.getTitle());
            System.out.println("✅ ARTIST: " + song.getArtist().getFullName());
            System.out.println("✅ FILE PATH: " + song.getFilePath());
            System.out.println("✅ ALLOW DOWNLOAD: " + song.getAllowDownload());
            
            // Proveri da li je download dozvoljen
            if (!song.getAllowDownload()) {
                System.out.println("❌ DOWNLOAD DENIED: SONG DOES NOT ALLOW DOWNLOAD");
                return ResponseEntity.badRequest().build();
            }

            // Kreiraj pravilno ime fajla: "Izvođač - Pesma.wav"
            String fileName = generateFileName(song);
            System.out.println("🎵 DOWNLOAD FILENAME: " + fileName);

            System.out.println("🎵 DOWNLOAD APPROVED FOR: " + song.getTitle());
            
            // Pronađi fajl
            File audioFile = findAudioFile(song.getFilePath());
            
            if (audioFile == null || !audioFile.exists()) {
                System.out.println("❌ DOWNLOAD ERROR: FILE NOT FOUND");
                return ResponseEntity.notFound().build();
            }

            System.out.println("✅ FILE FOUND: " + audioFile.getAbsolutePath());
            System.out.println("✅ FILE SIZE: " + audioFile.length() + " bytes");

            Resource resource = new FileSystemResource(audioFile);
            
            // Kreiraj response za download sa pravim imenom fajla
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, 
                           "attachment; filename=\"" + fileName + "\"")
                    .header(HttpHeaders.CONTENT_TYPE, "audio/wav")
                    .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(audioFile.length()))
                    .body(resource);
                    
        } catch (Exception e) {
            System.out.println("❌ DOWNLOAD ERROR: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
    
    // Metoda za generisanje imena fajla u formatu "Izvođač - Pesma.wav"
    private String generateFileName(Song song) {
        String artistName = song.getArtist().getFullName();
        String songTitle = song.getTitle();
        
        // Čišćenje specijalnih karaktera koji mogu uzrokovati probleme u imenima fajlova
        String cleanArtist = cleanFileName(artistName);
        String cleanTitle = cleanFileName(songTitle);
        
        return cleanArtist + " - " + cleanTitle + ".wav";
    }
    
    // Pomoćna metoda za čišćenje nedozvoljenih karaktera u imenima fajlova
    private String cleanFileName(String fileName) {
        if (fileName == null) return "";
        
        // Ukloni karaktere koji nisu dozvoljeni u imenima fajlova
        return fileName.replaceAll("[\\\\/:*?\"<>|]", "_")
                      .replaceAll("\\s+", " ")
                      .trim();
    }
    
    private File findAudioFile(String filePath) {
        System.out.println("🔍 SEARCHING FOR FILE: " + filePath);
        
        // Lista mogućih lokacija
        String[] possiblePaths = {
            filePath, // original path
            filePath.startsWith("/") ? filePath.substring(1) : filePath, // bez početnog /
            "src/main/webapp" + filePath,
            "src/main/resources" + filePath,
            "target/classes/static" + filePath,
            "src/main/webapp/music/" + filePath.substring(filePath.lastIndexOf("/") + 1)
        };
        
        for (String path : possiblePaths) {
            File file = new File(path);
            if (file.exists()) {
                System.out.println("✅ FILE FOUND AT: " + path);
                return file;
            } else {
                System.out.println("❌ FILE NOT FOUND AT: " + path);
            }
        }
        
        System.out.println("❌ FILE NOT FOUND AT ANY LOCATION");
        return null;
    }

    // TEST METODA - provera da li controller radi
    @GetMapping("/test-download")
    @ResponseBody
    public String testDownload() {
        System.out.println("=== TEST DOWNLOAD ENDPOINT HIT ===");
        return "🎵 Download endpoint is working! SongController is registered!";
    }
    
    // TEST METODA za preview
    @GetMapping("/test-preview")
    @ResponseBody
    public String testPreview() {
        System.out.println("=== TEST PREVIEW ENDPOINT HIT ===");
        return "🎵 Preview endpoint is working!";
    }
    
    @GetMapping("/api/test-audio/{songId}")
    @ResponseBody
    public ResponseEntity<String> testAudio(@PathVariable Long songId) {
        System.out.println("🔊 TEST AUDIO ENDPOINT FOR SONG ID: " + songId);
        
        try {
            List<Song> allSongs = songService.getAllSongs();
            Song song = null;
            
            for (Song s : allSongs) {
                if (s.getId().equals(songId)) {
                    song = s;
                    break;
                }
            }
            
            if (song == null) {
                return ResponseEntity.status(404).body("❌ Song not found with ID: " + songId);
            }
            
            System.out.println("✅ Song found: " + song.getTitle());
            System.out.println("✅ File path: " + song.getFilePath());
            
            // Proveri da li fajl postoji
            File audioFile = findAudioFile(song.getFilePath());
            if (audioFile == null || !audioFile.exists()) {
                return ResponseEntity.status(404).body("❌ Audio file not found at: " + song.getFilePath());
            }
            
            return ResponseEntity.ok("✅ Audio file exists: " + audioFile.getAbsolutePath() + 
                                   " | Size: " + audioFile.length() + " bytes");
            
        } catch (Exception e) {
            return ResponseEntity.status(500).body("❌ Error: " + e.getMessage());
        }
    }
}