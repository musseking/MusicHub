package com.music.hub.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;

@Entity
@Table(name = "songs")
public class Song {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 255)
    @Column(nullable = false)
    private String title;

    @Size(max = 500)
    @Column(columnDefinition = "TEXT")
    private String description;

    @NotBlank
    @Column(name = "file_path", nullable = false)
    private String filePath;

    @NotNull
    private Integer duration;

    @Column(name = "file_size")
    private Long fileSize;

    @Column(name = "cover_image")
    private String coverImage;

    @Column(name = "release_year")
    private Integer releaseYear;

    @Column(name = "allow_download")
    private Boolean allowDownload = false;

    @Column(name = "is_approved")
    private Boolean isApproved = true;

    @Column(name = "is_premium")
    private Boolean isPremium = false;

    @Column(name = "play_count")
    private Long playCount = 0L;

    @Column(name = "download_count")
    private Long downloadCount = 0L;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "artist_id")
    private User artist;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "genre_id")
    private Genre genre;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "album_id")
    private Album album;

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getFilePath() { return filePath; }
    public Integer getDuration() { return duration; }
    public Long getFileSize() { return fileSize; }
    public String getCoverImage() { return coverImage; }
    public Integer getReleaseYear() { return releaseYear; }
    public Boolean getAllowDownload() { return allowDownload; }
    public Boolean getIsApproved() { return isApproved; }
    public Boolean getIsPremium() { return isPremium; }
    public Long getPlayCount() { return playCount; }
    public Long getDownloadCount() { return downloadCount; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public User getArtist() { return artist; }
    public Genre getGenre() { return genre; }
    public Album getAlbum() { return album; }

    public void setId(Long id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setDescription(String description) { this.description = description; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public void setDuration(Integer duration) { this.duration = duration; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public void setReleaseYear(Integer releaseYear) { this.releaseYear = releaseYear; }
    public void setAllowDownload(Boolean allowDownload) { this.allowDownload = allowDownload; }
    public void setIsApproved(Boolean isApproved) { this.isApproved = isApproved; }
    public void setIsPremium(Boolean isPremium) { this.isPremium = isPremium; }
    public void setPlayCount(Long playCount) { this.playCount = playCount; }
    public void setDownloadCount(Long downloadCount) { this.downloadCount = downloadCount; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public void setArtist(User artist) { this.artist = artist; }
    public void setGenre(Genre genre) { this.genre = genre; }
    public void setAlbum(Album album) { this.album = album; }
}