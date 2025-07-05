import java.io.File;
import java.io.IOException;
import java.util.Arrays;

public class X264Converter {
    public static void main(String[] args) {
        if (args.length < 3) {
            System.out.println("用法: java X264Converter <輸入目錄> <輸出目錄> <輸入副檔名>");
            return;
        }

        String inputDir = args[0];
        String outputDir = args[1];
        String fileExtension = args[2];

        File inputFolder = new File(inputDir);
        File outputFolder = new File(outputDir);

        if (!inputFolder.exists() || !inputFolder.isDirectory()) {
            System.out.println("輸入目錄不存在或不是目錄");
            return;
        }
        
        if (!outputFolder.exists()) {
            outputFolder.mkdirs();
        }

        File[] files = inputFolder.listFiles((dir, name) -> name.toLowerCase().endsWith("." + fileExtension));
        if (files == null || files.length == 0) {
            System.out.println("沒有找到符合條件的檔案");
            return;
        }

        Arrays.stream(files).forEach(file -> convertToX264(file, outputDir));
    }

    private static void convertToX264(File inputFile, String outputDir) {
        String outputFilePath = outputDir + File.separator + inputFile.getName().replaceFirst("\\.[^.]+$", ".mkv");
        
        String command = String.format(
            "ffmpeg -i %s -c:v libx264 -preset slow -crf 23  -c:a copy -c:s copy %s",
            inputFile.getAbsolutePath(), outputFilePath
        );

	System.out.println("指令: "+ command );


        try {
            Process process = Runtime.getRuntime().exec(command);
            process.waitFor();
            System.out.println("轉換完成: " + outputFilePath);
        } catch (IOException | InterruptedException e) {
            System.err.println("轉換失敗: " + inputFile.getName());
            e.printStackTrace();
        }
    }
}
