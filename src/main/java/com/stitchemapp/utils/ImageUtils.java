package com.stitchemapp.utils;

import java.awt.Dimension;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;

import javax.imageio.ImageIO;

import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;

import com.stitchemapp.constants.Constants;
import com.stitchemapp.entities.ImageFile;
import com.stitchemapp.enums.ProjectType;

public class ImageUtils {
	
	public static final Logger LOGGER = Logger.getLogger(ImageUtils.class);
	

	public static byte[] createThumbnailOutOfImage(BufferedImage sourceImage, ProjectType projectType) {
		// For now we are scaling based on the image width

		try {

			// Thumb nail

			int thumbNailWidth = projectType.maxThumbNailWidth();
			int thumbNailHeight = projectType.maxThumbNailHeight();

			int imgType = sourceImage.getType() == 0 ? BufferedImage.TYPE_INT_ARGB
					: sourceImage.getType();

			// BufferedImage bufferedThumbnail =
			// Thumbnails.of(sourceImage).size(thumbNailWidth,
			// thumbNailHeight).asBufferedImage();

			Image thumbnail = sourceImage.getScaledInstance(thumbNailWidth, -1,
					Image.SCALE_SMOOTH);
			BufferedImage bufferedThumbnail = new BufferedImage(
					thumbnail.getWidth(null), thumbnail.getHeight(null),
					imgType);
			bufferedThumbnail.getGraphics().drawImage(thumbnail, 0, 0, null);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] thumbnailInByte = null;

			try {
				ImageIO.write(bufferedThumbnail, "jpg", baos);
				baos.flush();
				thumbnailInByte = baos.toByteArray();
				baos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}

			return thumbnailInByte;

		} catch (Exception e) {
			// TODO: handle exception
		}

		return null;
	}

	public static void resize(File inFile, Dimension inDimension, File outFile, 
			float compressionQuality, int width, int height, 
			boolean square, String format) throws IOException {
		
		Process process = null;
		try {

			String convertPath = new File(Constants.IMAGEMAGICK_PATH, "convert").getAbsolutePath();
			String compression = String.valueOf((int) (compressionQuality * 100));

			int origHeight = inDimension.height;
			int origWidth = inDimension.width;
			final boolean shouldResize = origWidth > width || origHeight > height;

			ArrayList<String> args = new ArrayList<String>();
			args.add(convertPath);
			args.add("-flatten");
			args.add("-strip");
			args.add("-format");
			args.add(format);
			args.add("-quality");
			args.add(compression);
			if (square) {
				args.add("-resize");
				args.add("x" + 2 * width);
				args.add("-resize");
				args.add(2 * width + "x<");
				args.add("-resize");
				args.add("50%");
				args.add("-gravity");
				args.add("center");
				args.add("-crop");
				args.add(width + "x" + width + "+0+0");
				args.add("+repage");
			} else if (shouldResize) {
				args.add("-resize");
				args.add(width + "x" + height + ">");
			}

			args.add(inFile.getAbsolutePath());
			args.add(outFile.getAbsolutePath());
			String[] commands = args.toArray(new String[args.size()]);

			process = Runtime.getRuntime().exec(commands);
			int exit = process.waitFor();
			if (exit != 0) {
				BufferedReader stdInput = new BufferedReader(
						new InputStreamReader(process.getErrorStream()));
				StringBuffer sb = new StringBuffer();

				String line;
				while ((line = stdInput.readLine()) != null) {
					sb.append(line).append("\n");
				}

				IOException ex = new IOException(
						"ImageMagick exited with exit code: " + exit);
				LOGGER.info(
						"This cmd ["
								+ Arrays.asList(commands)
								+ "] to create thumbnail "
								+ "failed. Check if the imagmagick version installed. Error is ["
								+ sb.toString() + "]", ex);
				throw ex;
			}

		} catch (InterruptedException e) {
			IOException ex = new IOException();
			ex.initCause(e);
			throw ex;
		} finally {
//			clear(process);
		}
	}

	public static byte[] createThumbnailUsingImageMagick(ImageFile imageFile,
			ProjectType projectType) {
		
		File infile = imageFile.getFileObj();
		String fileName = infile.getName();
		
		String filePath = infile.getAbsolutePath();
		
//		String fileType = infile.getContentType();
//		System.out.println(fileType);
		
		File outFile = new File(fileName + "-thumbnail");
		String opfilePath = outFile.getAbsolutePath();
		
		
		Dimension inDimension = new Dimension(imageFile.getWidth(), imageFile.getHeight());
		
		
//		File newFile = new File(tempDirPath, fileName);
//		imageFile.getFileObj().transferTo(newFile);
		
//		try {
//			resize(infile, inDimension, outFile, 1, Constants.DEFAULT_THUMB_NAIL_WIDTH, Constants.DEFAULT_THUMB_NAIL_HEIGHT, false, "jpg");
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
		// TODO Auto-generated method stub
		return null;
	}

}
