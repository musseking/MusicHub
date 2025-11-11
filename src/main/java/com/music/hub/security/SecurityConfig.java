package com.music.hub.security;

import org.springframework.boot.CommandLineRunner;
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
	private final DeactivatedAccountFilter deactivatedAccountFilter;

	public SecurityConfig(UserDetailsService userDetailsService, DeactivatedAccountFilter deactivatedAccountFilter) {
		this.userDetailsService = userDetailsService;
		this.deactivatedAccountFilter = deactivatedAccountFilter;
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		System.out.println("=== CONFIGURING SECURITY - PUBLIC ACCESS WITH LOGIN OPTION ===");

		http.authorizeHttpRequests(authz -> authz
				.requestMatchers("/", "/index", "/login", "/static/**", "/css/**", "/js/**", "/images/**", "/music/**",
						"/WEB-INF/jsp/**").permitAll()
				.requestMatchers("/reports/admin/**").hasRole("ADMIN")
				.requestMatchers("/reports/artist/**").hasAnyRole("ARTIST", "ADMIN")
				.requestMatchers("/reports/**").authenticated()
				.requestMatchers("/download/**", "/users", "/users/**").authenticated()
				.requestMatchers("/admin/**").hasRole("ADMIN")
				.requestMatchers("/artist/**").hasAnyRole("ARTIST", "ADMIN")
				.requestMatchers("/admin/register-user").hasRole("ADMIN")
				.requestMatchers("/register", "/admin/register-artist").permitAll().anyRequest().permitAll())
				.formLogin(form -> form.loginPage("/login").loginProcessingUrl("/login").defaultSuccessUrl("/", true)
						.failureUrl("/login?error=true").permitAll())
				.logout(logout -> logout.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
						.logoutSuccessUrl("/?logout=true").invalidateHttpSession(true).deleteCookies("JSESSIONID")
						.permitAll())
				.addFilterBefore(deactivatedAccountFilter,
						org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class)
				.userDetailsService(userDetailsService).csrf(csrf -> csrf.disable());

		return http.build();
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public CommandLineRunner testPassword() {
		return args -> {
			PasswordEncoder encoder = passwordEncoder();
			String testPassword = "password123";
			String encoded = encoder.encode(testPassword);

			System.out.println("=== PASSWORD ENCODING TEST ===");
			System.out.println("Raw password: " + testPassword);
			System.out.println("Encoded: " + encoded);
			System.out.println("Matches stored: "
					+ encoder.matches(testPassword, "$2a$10$8.UnVuG9HHgffUDAlk8qfOuW6.5d1uZ1V.8A9a7J.F.6zB0.7Q.6K"));
			System.out.println("=== END TEST ===");
		};
	}

	@Bean
	public CommandLineRunner resetPassword() {
		return args -> {
			PasswordEncoder encoder = passwordEncoder();
			String newEncodedPassword = encoder.encode("password123");
			System.out.println("=== NEW PASSWORD HASH ===");
			System.out.println(newEncodedPassword);
			System.out.println("=== UPDATE YOUR DATABASE WITH THIS ===");
		};
	}
}