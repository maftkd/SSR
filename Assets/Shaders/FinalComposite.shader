Shader "Hidden/FinalComposite"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _GAlbedo;
            sampler2D _GNormal;
            sampler2D _GPosition;
            
            sampler2D _AmbientOcclusion;
            sampler2D _ReflectionTexture;
            float4x4 _ViewMatrix;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 col = 0;
                float4 albedo = tex2D(_GAlbedo, i.uv);
                col = albedo.rgb;
                float3 reflection = tex2D(_ReflectionTexture, i.uv).rgb;
                col = lerp(col, tex2D(_GAlbedo, reflection.xy), albedo.a * reflection.z);
                float ssao = tex2D(_AmbientOcclusion, i.uv).r;
                col *= ssao;
                return float4(col, 1);
                return ssao;
            }
            ENDCG
        }
    }
}
