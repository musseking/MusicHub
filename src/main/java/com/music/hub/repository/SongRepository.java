package com.music.hub.repository;

import com.music.hub.entity.Song;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SongRepository extends JpaRepository<Song, Long> {
    
    @Query("SELECT s FROM Song s " +
           "LEFT JOIN FETCH s.artist " +
           "LEFT JOIN FETCH s.genre " +
           "LEFT JOIN FETCH s.album")
    List<Song> findAllWithArtistAndGenre();
}