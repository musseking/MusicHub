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
        
        if (userRepository.findByUsername(username).isPresent()) {
            throw new RuntimeException("Username already exists: " + username);
        }
        
        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email already exists: " + email);
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setIsArtist(Boolean.TRUE.equals(isArtist));
        user.setIsActive(true);
        user.setIsAdmin(false);

        return userRepository.save(user);
    }

    @Transactional
    public User registerArtistByAdmin(String username, String email, String password,
                                    String firstName, String lastName, String bio) {
        
        User user = registerUser(username, email, password, firstName, lastName, true);
        
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

    public List<User> getAllUsers() {
        return userRepository.findAllUsersOrdered();
    }
    
    public List<User> getAllArtists() {
        return userRepository.findAllArtists();
    }
    
    public List<User> getAllRegularUsers() {
        return userRepository.findAllRegularUsers();
    }
    
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
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