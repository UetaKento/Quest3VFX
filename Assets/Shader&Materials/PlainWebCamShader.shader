Shader "Unlit/PlainWebCamShader"
{
    Properties
    {
        _MainTex ("WebCam Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                 i.uv.x = 1.0 - i.uv.x; // ç∂âEîΩì]
                 i.uv.y = 1.0 - i.uv.y; // è„â∫îΩì]
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
