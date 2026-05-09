import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  const { title, category, expiry_date, images_urls, today } = await req.json();

  const expiryDate = new Date(expiry_date);
  const todayDate = new Date(today);
  const daysRemaining = Math.floor((expiryDate.getTime() - todayDate.getTime()) / 86400000);

  const limits: Record<string, number> = {
    alimentaire: 90,
    cosmetique: 120,
    electronique: 9999,
    autre: 90,
  };

  const maxDays = limits[category] ?? 90;

  if (daysRemaining < 1) {
    return new Response(JSON.stringify({
      validated: false,
      ai_score: 0,
      rejection_reason: "Produit déjà périmé",
    }), { headers: { "Content-Type": "application/json" } });
  }

  if (daysRemaining > maxDays) {
    return new Response(JSON.stringify({
      validated: false,
      ai_score: 0,
      rejection_reason: `Péremption trop lointaine pour la catégorie "${category}" (max ${maxDays} jours)`,
    }), { headers: { "Content-Type": "application/json" } });
  }

  const aiScore = Math.min(0.95, 0.6 + (daysRemaining / maxDays) * 0.35);
  const validated = daysRemaining >= 1 && daysRemaining <= maxDays;

  return new Response(JSON.stringify({
    validated,
    ai_score: aiScore,
    rejection_reason: validated ? null : "Catégorie non reconnue",
    extracted_info: { title, category, days_remaining: daysRemaining },
  }), { headers: { "Content-Type": "application/json" } });
});