# OCR Workflow Testing Guide

## Prerequisites

### 1. Supabase Storage Bucket
Ensure the `ocr-images` bucket exists in your Supabase project:

**Via Supabase Dashboard:**
1. Go to Storage → Buckets
2. Create new bucket: `ocr-images`
3. Set as **Public** (for public URL access)

**Via SQL:**
```sql
-- Check if bucket exists
SELECT * FROM storage.buckets WHERE name = 'ocr-images';

-- If not, create it via Dashboard (recommended)
```

### 2. Desktop Worker Running
Your Python worker must be running and polling:

```bash
# Start the worker
python worker.py
```

Expected output:
```
🚀 Initialisation du worker OCR...
✅ Connexion établie avec Supabase et serveur OCR local
============================================================
🤖 WORKER OCR DÉMARRÉ
============================================================
📡 Serveur OCR: http://localhost:8000/v1
🗄️ Supabase: https://ngrmtwhlzehyjqcdspqh.supabase.co
⏱️ Intervalle de polling: 5s
============================================================

⏳ En attente de jobs... (Ctrl+C pour arrêter)
```

### 3. OCR Server Running
Your local OCR server must be active:

```bash
# Check if server is running
curl http://localhost:8000/v1/models
```

## Testing Steps

### Test 1: Basic Upload and Processing

1. **Launch App**
   ```bash
   flutter run
   ```

2. **Navigate to Scan**
   - Tap the "Scan" tab in bottom navigation

3. **Capture/Upload Image**
   - Option A: Tap camera button to scan document
   - Option B: Tap gallery icon to upload from photos

4. **Preview & Confirm**
   - Review the captured image
   - Tap "Use This" button

5. **Watch Processing**
   - You should see the OCR processing screen
   - Status will update: `Uploading → Pending → Processing → Completed`
   - Desktop worker logs should show job pickup

6. **View Result**
   - OCR text result will display on success
   - Screen auto-closes after 2 seconds

### Test 2: Verify Database

Check that jobs are being created:

```sql
-- View recent jobs
SELECT 
  id,
  image_name,
  status,
  created_at,
  completed_at,
  LEFT(result, 50) as result_preview
FROM ocr_jobs 
ORDER BY created_at DESC 
LIMIT 5;
```

### Test 3: Verify Storage

Check uploaded images in Supabase:

1. Go to Storage → `ocr-images` bucket
2. You should see uploaded images with timestamps
3. Click image to view public URL

### Test 4: Error Handling

**Test Worker Offline:**
1. Stop the desktop worker
2. Upload an image
3. Should see "Waiting for worker..." status
4. Restart worker - job should process automatically

**Test Network Error:**
1. Disable internet
2. Try to upload image
3. Should see upload error with retry option

## Monitoring

### App Debug Logs
Enable debug mode to see detailed logs:

```dart
// Already enabled in debug mode
debugPrint('[OcrRepository] ...');
debugPrint('[OcrNotifier] ...');
debugPrint('[SupabaseService] ...');
```

### Worker Logs
Watch worker console for:
- Job detection: `📋 X job(s) en attente`
- Processing: `🔄 Traitement du job...`
- Success: `✅ Job terminé avec succès!`
- Errors: `❌ Erreur: ...`

### Supabase Realtime (Optional)
Monitor database changes in real-time:

```sql
-- In Supabase SQL Editor
LISTEN ocr_jobs_changes;
```

## Expected Timings

| Stage | Duration |
|-------|----------|
| Image Upload | 1-3 seconds |
| Job Creation | < 1 second |
| Worker Pickup | 0-5 seconds (polling interval) |
| OCR Processing | 5-15 seconds (depends on image) |
| Result Display | Immediate |

**Total**: ~10-25 seconds end-to-end

## Troubleshooting

### Issue: "Upload Failed"
**Causes:**
- No internet connection
- Supabase credentials incorrect
- Storage bucket doesn't exist or is private

**Solutions:**
1. Check internet connection
2. Verify Supabase URL and key in `supabase_config.dart`
3. Ensure `ocr-images` bucket exists and is public

### Issue: Job Stuck on "Pending"
**Causes:**
- Desktop worker not running
- Worker can't connect to Supabase
- Worker polling interval too long

**Solutions:**
1. Start/restart desktop worker
2. Check worker logs for connection errors
3. Verify worker Supabase credentials match app

### Issue: Job Stuck on "Processing"
**Causes:**
- OCR server not running
- OCR model loading failed
- Image too large or corrupted

**Solutions:**
1. Check OCR server status: `curl http://localhost:8000/v1/models`
2. Restart OCR server
3. Check worker error logs
4. Try with a smaller, clearer image

### Issue: "OCR Failed"
**Causes:**
- OCR processing error
- Model inference failed
- Timeout

**Solutions:**
1. Check worker logs for specific error
2. Verify OCR model is loaded correctly
3. Try with a different image
4. Check GPU/CUDA availability

## Performance Tips

### For Faster Processing:
1. **Compress Images**: Add image compression before upload
   ```dart
   // In ocr_repository.dart, before upload
   final compressedBytes = await compressImage(imageBytes);
   ```

2. **Reduce Polling Interval**: Change from 3s to 2s
   ```dart
   // In ocr_repository.dart
   Duration pollInterval = const Duration(seconds: 2),
   ```

3. **Use Supabase Realtime**: Replace polling with subscriptions
   ```dart
   // Future enhancement
   supabase.from('ocr_jobs').stream(...);
   ```

## Success Criteria

✅ Image uploads to Supabase Storage  
✅ OCR job created with `pending` status  
✅ Desktop worker picks up job within 5 seconds  
✅ Job status updates to `processing`  
✅ OCR completes and returns text result  
✅ Job status updates to `completed`  
✅ App displays OCR result  
✅ All 3 languages (EN/FR/AR) work correctly  

## Next Steps After Testing

1. **Add Image Compression**: Reduce upload size
2. **Implement Realtime**: Replace polling with Supabase Realtime
3. **Add User Auth**: Link jobs to authenticated users
4. **Parse Invoice Data**: Extract structured data from OCR text
5. **Add Retry Logic**: Auto-retry failed jobs
6. **Cache Results**: Store completed OCR results locally

---

**Ready to Test!** 🚀

Start your desktop worker, run the app, and scan your first invoice!
