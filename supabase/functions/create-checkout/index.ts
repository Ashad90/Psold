import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const stripeSecretKey = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
const STRIPE_PRICE_ID = Deno.env.get("STRIPE_PRICE_ID") ?? "price_xxxxxxx";

serve(async (req) => {
  try {
    const { user_id, success_url, cancel_url } = await req.json();

    if (!user_id) {
      return new Response(JSON.stringify({ error: "user_id is required" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const stripe = await import("https://esm.sh/stripe@17.7.0?target=deno");
    const client = stripe.default(stripeSecretKey, {
      apiVersion: "2025-04-10",
      httpClient: stripe.default.createFetchHttpClient(),
    });

    const session = await client.checkout.sessions.create({
      mode: "payment",
      line_items: [{ price: STRIPE_PRICE_ID, quantity: 1 }],
      client_reference_id: user_id,
      metadata: { user_id },
      success_url: success_url ?? "https://dsflswhxvjnvkedhrynd.supabase.co/functions/v1/stripe-webhook?success=true",
      cancel_url: cancel_url ?? "https://dsflswhxvjnvkedhrynd.supabase.co/functions/v1/stripe-webhook?canceled=true",
    });

    return new Response(JSON.stringify({ url: session.url }), {
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
