import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const stripeSecretKey = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
const stripeWebhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET") ?? "";

serve(async (req) => {
  try {
    const signature = req.headers.get("stripe-signature");
    if (!signature) {
      return new Response(JSON.stringify({ error: "Missing stripe-signature header" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const body = await req.text();
    const stripe = await import("https://esm.sh/stripe@17.7.0?target=deno");
    const client = stripe.default(stripeSecretKey, {
      apiVersion: "2025-04-10",
      httpClient: stripe.default.createFetchHttpClient(),
    });

    let event;
    try {
      event = client.webhooks.constructEvent(body, signature, stripeWebhookSecret);
    } catch {
      return new Response(JSON.stringify({ error: "Invalid signature" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const userId = session.metadata?.user_id ?? session.client_reference_id;

      if (userId) {
        const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
        const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

        const res = await fetch(`${supabaseUrl}/rest/v1/profiles?id=eq.${userId}`, {
          method: "PATCH",
          headers: {
            "Content-Type": "application/json",
            "apikey": serviceRoleKey,
            "Authorization": `Bearer ${serviceRoleKey}`,
            "Prefer": "return=minimal",
          },
          body: JSON.stringify({
            is_premium: true,
            premium_since: new Date().toISOString(),
          }),
        });

        if (!res.ok) {
          console.error("Failed to update profile:", await res.text());
        }
      }
    }

    return new Response(JSON.stringify({ received: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
