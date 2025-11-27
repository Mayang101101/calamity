-- ============================================
-- EMERGENCY KIT CHECKLIST - DATABASE SETUP
-- ============================================
-- Copy and paste this entire script into Supabase SQL Editor
-- Then click "Run" to create the database table

-- Step 1: Drop old table if exists
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS emergency_items CASCADE;

-- Step 2: Create emergency_items table
CREATE TABLE emergency_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  item_name TEXT NOT NULL,
  category TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  is_ready BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Enable Row Level Security
ALTER TABLE emergency_items ENABLE ROW LEVEL SECURITY;

-- Step 4: Create policy to allow all operations
CREATE POLICY "Allow all operations" 
ON emergency_items 
FOR ALL 
USING (true);

-- Step 5: Create index for better performance
CREATE INDEX idx_emergency_category ON emergency_items(category);
CREATE INDEX idx_emergency_is_ready ON emergency_items(is_ready);

-- Step 6: Insert sample data (optional - for testing)
INSERT INTO emergency_items (item_name, category, quantity, is_ready) VALUES
('Flashlight', 'Tools', 2, true),
('Batteries (AA)', 'Tools', 10, true),
('First Aid Kit', 'Medicine', 1, true),
('Canned Goods', 'Food', 5, false),
('Bottled Water (1L)', 'Water', 10, true),
('Blanket', 'Clothing', 3, false),
('Important Documents', 'Documents', 1, false),
('Whistle', 'Tools', 2, true),
('Radio (Battery-powered)', 'Tools', 1, false),
('Paracetamol', 'Medicine', 1, true);

-- Success! Your database is ready to use.
-- Now update your lib/config/supabase_config.dart with your credentials.
