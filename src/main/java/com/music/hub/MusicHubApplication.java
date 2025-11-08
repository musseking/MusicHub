	package com.music.hub;
	
	import org.springframework.boot.SpringApplication;
	import org.springframework.boot.autoconfigure.SpringBootApplication;
	
	@SpringBootApplication(scanBasePackages = "com.music.hub")
	public class MusicHubApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(MusicHubApplication.class, args);
		}
	}
