import java.nio.*;

ByteBuffer byteBuffer;
IntBuffer intBuffer;
OutputStream video;
boolean isVideoInitialized=false; 

void initVideoCapture(String name, float fps) {
  video = videoOutputStream(name, fps);
  byteBuffer = ByteBuffer.allocate(width * height * 4);
  intBuffer = byteBuffer.asIntBuffer();
  isVideoInitialized=true;
}

void addFrame() {
  if (isVideoInitialized) {
    loadPixels();
    try {
      intBuffer.rewind();
      intBuffer.put(pixels);
      video.write(byteBuffer.array());
    } 
    catch (IOException ioe) {
    }
  }
}

OutputStream videoOutputStream(String fname, float fps) {
  try {
    return new ProcessBuilder(
      "ffmpeg.exe", // or avconv
      "-f", "rawvideo", // input format
      "-pix_fmt", "argb", // pixel format
      "-r", fps+"", // frame rate
      "-s", width+"x"+height, // input size (window size)
      "-i", "-", // input (stdin)
      "-y", // force overwrite
      "-qscale", "0", // highest quantization quality profile,
      fname // output file
      // inherit stderr to catch ffmpeg errors
      ).redirectError(ProcessBuilder.Redirect.INHERIT).start().getOutputStream();
  } 
  catch (Exception e) {
    e.printStackTrace();
    System.exit(1);
    return null;
  }
}