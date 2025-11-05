package com.music.hub.repository;

import com.music.hub.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
    
    Optional<User> findByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.username = :username AND u.isActive = true")
    Optional<User> findActiveUserByUsername(@Param("username") String username);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    // Dohvati sve korisnike sortirane po tipu
    @Query("SELECT u FROM User u ORDER BY u.isAdmin DESC, u.isArtist DESC, u.username ASC")
    List<User> findAllUsersOrdered();
    
    // Dohvati sve artiste
    @Query("SELECT u FROM User u WHERE u.isArtist = true ORDER BY u.username ASC")
    List<User> findAllArtists();
    
    // Dohvati sve obične korisnike
    @Query("SELECT u FROM User u WHERE u.isArtist = false AND u.isAdmin = false ORDER BY u.username ASC")
    List<User> findAllRegularUsers();
}