package com.music.hub.security;

import com.music.hub.repository.UserRepository;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class DeactivatedAccountFilter extends OncePerRequestFilter {

    private final UserRepository userRepository;

    public DeactivatedAccountFilter(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        
        // Proveravamo samo POST zahteve na /login
        if ("/login".equals(request.getServletPath()) && "POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            
            if (username != null && !username.trim().isEmpty()) {
                // Proverimo da li korisnik postoji i da li je deaktiviran
                var userOpt = userRepository.findByUsername(username);
                if (userOpt.isPresent() && !userOpt.get().getIsActive()) {
                    // Korisnik je deaktiviran - preusmeri sa custom porukom
                    request.getSession().setAttribute("LOGIN_ERROR_MESSAGE", 
                        "Sorry, your account is temporarily deactivated, contact admin for help");
                    response.sendRedirect("/login?error=true");
                    return; // NE NASTAVLJAJ FILTER CHAIN
                }
            }
        }
        
        // Nastavi normalno ako nije deaktivirani korisnik
        filterChain.doFilter(request, response);
    }
}