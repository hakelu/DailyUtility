import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.util.concurrent.*;

public class FLACToMP3ConverterMulti {

    // 用來執行 FLAC 到 MP3 轉換的任務
    private static class ConversionTask implements Runnable {
        private final File flacFile;
        private final File mp3File;

        public ConversionTask(File flacFile, File mp3File) {
            this.flacFile = flacFile;
            this.mp3File = mp3File;
        }

        @Override
        public void run() {
            try {
                // 執行 FFmpeg 命令來轉換 FLAC 為 MP3
                System.out.println("Converting: " + flacFile + " to " + mp3File);
                ProcessBuilder processBuilder = new ProcessBuilder("ffmpeg", "-i", flacFile.getAbsolutePath(),
                        "-vn", "-ar", "44100", "-ac", "2", "-ab", "320k", mp3File.getAbsolutePath());
                Process process = processBuilder.start();
                process.waitFor();
                System.out.println("Converted: " + flacFile + " to " + mp3File);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 用來處理多線程轉換
    public static void convertFLACToMP3(File sourceDir, File destDir, int threadCount) throws IOException {
        ExecutorService executor = Executors.newFixedThreadPool(threadCount); // 設定線程池，最多可以並行處理 threadCount 個任務

        Files.walk(sourceDir.toPath())
            .filter(p -> p.toString().endsWith(".flac"))
            .forEach(p -> {
                try {
                    File flacFile = p.toFile();
                    String relativePath = sourceDir.toPath().relativize(p).toString();
                    File mp3File = new File(destDir, relativePath.replace(".flac", ".mp3"));
                    mp3File.getParentFile().mkdirs();

                    // 提交轉換任務到線程池
                    executor.submit(new ConversionTask(flacFile, mp3File));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });

        // 關閉線程池
        executor.shutdown();
        try {
            if (!executor.awaitTermination(60, TimeUnit.MINUTES)) {
                executor.shutdownNow();
            }
        } catch (InterruptedException e) {
            executor.shutdownNow();
        }
    }

    public static void main(String[] args) throws IOException {
        if (args.length < 3) {
            System.out.println("Usage: java FLACToMP3Converter <sourceDir> <destDir> <threadCount>");
            return;
        }

        String sourcePath = args[0];
        String destPath = args[1];
        int threadCount = Integer.parseInt(args[2]);

        File sourceDir = new File(sourcePath);
        File destDir = new File(destPath);

        System.out.println("Source directory: " + sourceDir);
        System.out.println("Destination directory: " + destDir);
        System.out.println("Number of threads: " + threadCount);

        convertFLACToMP3(sourceDir, destDir, threadCount);
    }
}

