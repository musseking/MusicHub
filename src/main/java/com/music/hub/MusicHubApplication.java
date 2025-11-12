package com.music.hub;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = "com.music.hub")
public class MusicHubApplication {

	public static void main(String[] args) {
		SpringApplication.run(MusicHubApplication.class, args);
		System.out.println("=== MUSIC HUB APPLICATION STARTED ===");
	}
}