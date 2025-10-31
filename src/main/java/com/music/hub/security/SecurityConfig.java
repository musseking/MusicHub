package com.music.hub.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserDetailsService userDetailsService;

    public SecurityConfig(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        System.out.println("=== CONFIGURING SECURITY - PUBLIC ACCESS WITH LOGIN OPTION ===");
        
        http
            .authorizeHttpRequests(authz -> authz
                // JAVNE RUTE - svi mogu pristupiti (i nelogovani)
                .requestMatchers(
                    "/", "/index",  
                    "/login", "/static/**",
                    "/css/**", "/js/**", "/images/**",
                    "/WEB-INF/jsp/**"  // dozvoli pristup JSP fajlovima
                ).permitAll()
                
                // ZAŠTIĆENE RUTE - samo za logovane korisnike
                .requestMatchers("/download/**", "/user/**").authenticated()
                
                // ADMIN RUTE - samo za admine
                .requestMatchers("/admin/**").hasRole("ADMIN")
                
                // ARTIST RUTE - samo za artiste
                .requestMatchers("/artist/**").hasRole("ARTIST")
                
                // SVE OSTALO - dozvoli svima (kao što želiš)
                .anyRequest().permitAll()
            )
            
            // OMOGUĆI FORM LOGIN (kao što želiš)
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/", true)  // nakon logina, vrati na index
                .failureUrl("/login?error=true")
                .permitAll()
            )
            
            // OMOGUĆI LOGOUT (opciono)
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessUrl("/?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            
            // KORISTI CUSTOM USER DETAILS SERVICE
            .userDetailsService(userDetailsService)
            
            // CSRF može ostati disable za testiranje
            .csrf(csrf -> csrf.disable());

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}