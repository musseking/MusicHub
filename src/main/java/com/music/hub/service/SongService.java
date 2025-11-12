package com.music.hub.service;

import java.io.File;
import java.util.List;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import com.music.hub.entity.Song;
import com.music.hub.repository.SongRepository;

@Service
public class SongService {
    private final SongRepository repo;

    public SongService(SongRepository repo) {
        this.repo = repo;
    }

    public List<Song> getAllSongs() {
        return repo.findAllWithArtistAndGenre();
    }

    public ResponseEntity<Resource> streamSong(Long songId, Authentication authentication) {
        try {
            Song song = repo.findById(songId)
                    .orElseThrow(() -> new RuntimeException("Song not found with ID: " + songId));
            
            System.out.println("🎵 Streaming: " + song.getTitle());
            System.out.println("🎵 File path: " + song.getFilePath());
            
            File audioFile = findAudioFile(song.getFilePath());
            
            if (!audioFile.exists()) {
                System.out.println("❌ File not found: " + song.getFilePath());
                return ResponseEntity.notFound().build();
            }
            
            System.out.println("✅ File found: " + audioFile.getAbsolutePath());
            System.out.println("✅ File size: " + audioFile.length() + " bytes");

            Resource resource = new FileSystemResource(audioFile);
            
            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Type", "audio/wav");
            headers.add("Content-Length", String.valueOf(audioFile.length()));
            headers.add("Accept-Ranges", "bytes");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);
                    
        } catch (Exception e) {
            System.out.println("❌ Stream error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }


    public ResponseEntity<Resource> previewSong(Long songId) {
        try {
            Song song = repo.findById(songId)
                    .orElseThrow(() -> new RuntimeException("Song not found with ID: " + songId));
            
            System.out.println("🎵 Preview: " + song.getTitle());
            System.out.println("🎵 File path: " + song.getFilePath());
            
            File audioFile = findAudioFile(song.getFilePath());
            
            if (!audioFile.exists()) {
                System.out.println("❌ File not found: " + song.getFilePath());
                return ResponseEntity.notFound().build();
            }
            
            System.out.println("✅ File found: " + audioFile.getAbsolutePath());
            System.out.println("✅ File size: " + audioFile.length() + " bytes");

            Resource resource = new FileSystemResource(audioFile);
            
            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Type", "audio/wav");
            headers.add("Content-Length", String.valueOf(audioFile.length()));
            headers.add("Accept-Ranges", "bytes");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);
                    
        } catch (Exception e) {
            System.out.println("❌ Preview error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
    
    private File findAudioFile(String filePath) {
        System.out.println("🔍 SEARCHING FOR FILE: " + filePath);
        
        File file = new File(filePath);
        if (file.exists()) {
            System.out.println("✅ FILE FOUND AT ORIGINAL PATH: " + filePath);
            return file;
        }
        
        String[] possiblePaths = {
            filePath.startsWith("/") ? filePath.substring(1) : filePath,
            "src/main/webapp" + filePath,
            "src/main/resources" + filePath,
            "target/classes/static" + filePath,
            "src/main/webapp/music/" + getFileName(filePath),
            "music/" + getFileName(filePath),
            "src/main/webapp/static/music/" + getFileName(filePath),
            "static/music/" + getFileName(filePath)
        };
        
        for (String path : possiblePaths) {
            file = new File(path);
            System.out.println("🔍 Checking: " + path + " - exists: " + file.exists());
            if (file.exists()) {
                System.out.println("✅ FILE FOUND AT: " + path);
                return file;
            }
        }
        
        System.out.println("❌ FILE NOT FOUND AT ANY LOCATION");
        return new File("");
    }
    
    private String getFileName(String filePath) {
        if (filePath == null) return "";
        int lastSlash = filePath.lastIndexOf("/");
        return lastSlash >= 0 ? filePath.substring(lastSlash + 1) : filePath;
    }

    public String testAudioFile(Long songId) {
        try {
            Song song = repo.findById(songId)
                    .orElseThrow(() -> new RuntimeException("Song not found with ID: " + songId));
            
            File audioFile = findAudioFile(song.getFilePath());
            
            if (audioFile.exists()) {
                return "✅ Audio file exists: " + audioFile.getAbsolutePath() + " | Size: " + audioFile.length() + " bytes";
            } else {
                return "❌ Audio file NOT FOUND. Searched path: " + song.getFilePath();
            }
            
        } catch (Exception e) {
            return "❌ Error: " + e.getMessage();
        }
    }
}