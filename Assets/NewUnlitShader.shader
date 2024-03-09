Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _t ("t", Range(0, 1)) = 1.0
        _t2 ("t2", Range(0, 1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _t, _t2;

            v2f vert (appdata v)
            {
                v2f o;
                // float n = _ProjectionParams.y;
                // float f = _ProjectionParams.z;
                // float4x4 transf = float4x4(1, 0, 0, 0,
                //                            0, 1, 0, 0,
                //                            0, 0, 1, 1,
                //                            0, 0, 0, 1);
                float n = 1;
                float f = 2;
                float4x4 transf = float4x4(n, 0, 0, 0,
                                           0, n, 0, 0,
                                           0, 0, n+f, -n*f,
                                           0, 0, 1, 0);
                float4x4 scale = float4x4(1, 0, 0, 0,
                                          0, 1, 0, 0,
                                          0, 0, -1, 0,
                                          0, 0, 0, 1);
                float4x4 z = float4x4(1, 0, 0, 0,
                                      0, 1, 0, 0,
                                      0, 0, 0, n,
                                      0, 0, 0, 1);

                // P S(ZT)SVM*v
                float4 newv = mul(UNITY_MATRIX_MV, v.vertex);
                newv = mul(mul(mul(scale, lerp(transf, mul(z, transf), _t2)), scale), newv);
                // newv = mul(transf, newv);
                newv = mul(UNITY_MATRIX_P, newv);
                // newv.xyz /= newv.w;
                o.vertex = lerp(UnityObjectToClipPos(v.vertex), newv, _t);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                // float4 col;
                return float4(i.normal, 1.0);
            }

            ENDCG
        }
    }
}
