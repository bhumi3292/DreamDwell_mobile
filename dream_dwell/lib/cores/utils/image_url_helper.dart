class ImageUrlHelper {
  static String constructImageUrl(String imagePath, {String? baseUrl}) {
    print('DEBUG: ImageUrlHelper - Original path: $imagePath');
    
    if (imagePath.startsWith('http')) {
      print('DEBUG: ImageUrlHelper - Already a full URL: $imagePath');
      return imagePath;
    }
    
    final serverUrl = baseUrl ?? 'http://10.0.2.2:3001/';
    
    // Normalize the path to use forward slashes and remove any leading/trailing slashes
    final normalizedPath = imagePath.replaceAll('\\', '/').replaceAll(RegExp(r'^/+|/+$'), '');
    print('DEBUG: ImageUrlHelper - Normalized path: $normalizedPath');
    
    // The backend stores paths like "uploads\images-1752114249150-135906902.jpg"
    // but the actual files are just "images-1752114249150-135906902.jpg" in the uploads directory
    // So we need to extract just the filename part
    String filename;
    if (normalizedPath.startsWith('uploads/')) {
      // Remove the "uploads/" prefix to get just the filename
      filename = normalizedPath.substring('uploads/'.length);
    } else {
      // If no "uploads/" prefix, use the path as is
      filename = normalizedPath;
    }
    
    // Construct the final URL
    final fullUrl = '${serverUrl}uploads/$filename';
    
    print('DEBUG: ImageUrlHelper - Extracted filename: $filename');
    print('DEBUG: ImageUrlHelper - Final URL: $fullUrl');
    return fullUrl;
  }
} 