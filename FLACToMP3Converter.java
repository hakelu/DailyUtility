import javax.sound.sampled.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class FLACToMP3Converter {

    public static void convertFLACToMP3(File sourceDir, File destDir) throws IOException {
        Files.walk(sourceDir.toPath())
            .filter(p -> p.toString().endsWith(".flac"))
            .forEach(p -> {
                try {
                    File flacFile = p.toFile();
                    String relativePath = sourceDir.toPath().relativize(p).toString();
                    File mp3File = new File(destDir, relativePath.replace(".flac", ".mp3"));
                    mp3File.getParentFile().mkdirs();

                    // Use FFmpeg to convert FLAC to MP3 (Make sure FFmpeg is installed)
		    System.out.println("Ready convert file : " + flacFile + " to " + mp3File); 
                    ProcessBuilder processBuilder = new ProcessBuilder("ffmpeg", "-i", flacFile.getAbsolutePath(),
                            "-vn", "-ar", "44100", "-ac", "2", "-ab", "320k", mp3File.getAbsolutePath());
                    Process process = processBuilder.start();
                    process.waitFor();

                    System.out.println("Converted: " + flacFile + " to " + mp3File);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
    }

    public static void main(String[] args) throws IOException {
        System.out.println(args[0]);
        System.out.println(args[1]);

	File sourceDir = new File(args[0]);
        File destDir = new File(args[1]);
        convertFLACToMP3(sourceDir, destDir);
    }
}

