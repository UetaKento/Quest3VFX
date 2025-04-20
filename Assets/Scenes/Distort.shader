Shader "Unlit/Distort"
{
    Properties
    {
        _MainTex ("WebCam Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _DistortStrength ("Distortion Strength", Float) = 0.05
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
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _NoiseTex_ST;
            float _DistortStrength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv.x = 1.0 - i.uv.x; // ���E���]
                i.uv.y = 1.0 - i.uv.y; // �㉺���]
                float2 noiseUV = TRANSFORM_TEX(i.uv + float2(_Time.z,_Time.z), _NoiseTex); // �m�C�Y����c�݂��v�Z
                float2 noise = tex2D(_NoiseTex, noiseUV).rg; // R��G���g��
                noise = (noise - 0.5) * 2.0; // -0.5->+0.5�͈̔͂ɕϊ��i���S��0�j
                float2 distortedUV = i.uv + noise * _DistortStrength; // �c�݂�������UV���W

                fixed4 col = tex2D(_MainTex, distortedUV);
                float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
                return fixed4(gray, gray, gray, col.a);
            }
            ENDCG
        }
    }
}
