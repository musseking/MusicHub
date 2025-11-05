package com.music.hub.service;

import com.music.hub.entity.User;
import com.music.hub.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

//import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User registerUser(String username, String email, String password, 
                           String firstName, String lastName, Boolean isArtist) {
        
        // Proveri da li korisnik već postoji
        if (userRepository.findByUsername(username).isPresent()) {
            throw new RuntimeException("Username already exists: " + username);
        }
        
        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email already exists: " + email);
        }

        // Kreiraj novog korisnika
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setIsArtist(Boolean.TRUE.equals(isArtist));
        user.setIsActive(true);
        user.setIsAdmin(false); // Samo admin može da postavi admin privilegije
        // createdAt i updatedAt će se automatski postaviti preko @PrePersist

        return userRepository.save(user);
    }

    @Transactional
    public User registerArtistByAdmin(String username, String email, String password,
                                    String firstName, String lastName, String bio) {
        
        // Koristi postojeću registerUser metodu sa isArtist = true
        User user = registerUser(username, email, password, firstName, lastName, true);
        
        // Postavi bio za artist-a ako je prosleđen
        if (bio != null && !bio.trim().isEmpty()) {
            user.setBio(bio);
            userRepository.save(user);
        }

        return user;
    }
    
    @Transactional
    public boolean updateUserBio(Long userId, String bio) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setBio(bio);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    // Dohvati sve korisnike
    public List<User> getAllUsers() {
        return userRepository.findAllUsersOrdered();
    }
    
    // Dohvati sve artiste
    public List<User> getAllArtists() {
        return userRepository.findAllArtists();
    }
    
    // Dohvati sve obične korisnike
    public List<User> getAllRegularUsers() {
        return userRepository.findAllRegularUsers();
    }
    
    // Dohvati korisnika po ID
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
    // Deaktiviraj korisnika
    @Transactional
    public boolean deactivateUser(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(false);
            userRepository.save(user);
            return true;
        }
        return false;
    }
    
    // Aktiviraj korisnika
    @Transactional
    public boolean activateUser(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(true);
            userRepository.save(user);
            return true;
        }
        return false;
    }
}