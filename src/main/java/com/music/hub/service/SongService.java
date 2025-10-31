package com.music.hub.service;

import com.music.hub.entity.Song;
import com.music.hub.repository.SongRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SongService {
    private final SongRepository repo;

    public SongService(SongRepository repo) {
        this.repo = repo;
    }

    public List<Song> getAllSongs() {
        return repo.findAllWithArtistAndGenre();
    }
}