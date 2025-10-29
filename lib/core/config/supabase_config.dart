/// Supabase configuration constants
/// 
/// Contains the Supabase URL and anon key for connecting to the backend.
/// These values should be kept secure in production.
class SupabaseConfig {
  /// Supabase project URL
  static const String supabaseUrl = 'https://ngrmtwhlzehyjqcdspqh.supabase.co';
  
  /// Supabase anon/public key
  static const String supabaseAnonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ncm10d2hsemVoeWpxY2RzcHFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1ODUzNTgsImV4cCI6MjA3NzE2MTM1OH0.sHvp7MmSZtsFa1FzAu_0nZLvzB1zWsVRDbSZevUQ_Yk';
  
  /// Storage bucket name for OCR images
  static const String ocrImagesBucket = 'ocr-images';
  
  /// OCR jobs table name
  static const String ocrJobsTable = 'ocr_jobs';
  
  /// Invoices table name
  static const String invoicesTable = 'invoices';
}
