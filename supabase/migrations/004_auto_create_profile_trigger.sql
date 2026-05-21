-- Auto-create profile when user signs up via auth.users
-- This trigger runs AFTER insert on auth.users and creates a profile entry

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_role text;
  v_display_name text;
  v_whatsapp text;
  v_city text;
BEGIN
  -- Only auto-create if role is explicitly provided in metadata
  v_role := NEW.raw_user_meta_data->>'role';
  v_display_name := NEW.raw_user_meta_data->>'display_name';
  v_whatsapp := NEW.raw_user_meta_data->>'whatsapp';
  v_city := NEW.raw_user_meta_data->>'city';

  -- Skip auto-creation if no role provided (Google OAuth users will set it manually)
  IF v_role IS NULL THEN
    RETURN NEW;
  END IF;

  INSERT INTO public.profiles (id, role, display_name, whatsapp, city)
  VALUES (
    NEW.id,
    v_role,
    COALESCE(v_display_name, COALESCE(NEW.email, 'User')),
    v_whatsapp,
    v_city
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();