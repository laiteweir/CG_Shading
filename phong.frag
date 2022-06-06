precision highp float;

varying vec4 fragcolor;
varying vec3 vNormal;
varying vec3 vSurfaceToLight[4];
varying vec3 vSurfaceToView;

uniform int uEnable[4];
uniform float uShininess;
uniform float uInnerLimit;
uniform float uOuterLimit;
uniform vec3 uLightDirection;
    
void main(void)
{
    vec3 normal = normalize(vNormal);
    vec3 surfaceToViewDirection = normalize(vSurfaceToView);
    vec4 outColor = vec4(0, 0, 0, 1);

    for (int i = 0; i < 3; ++i)
    {
        if (uEnable[i] == 0)
        {
            continue;
        }

        vec3 surfaceToLightDirection = normalize(vSurfaceToLight[i]);
        vec3 halfVector = normalize(surfaceToLightDirection + surfaceToViewDirection);

        float light = dot(normal, surfaceToLightDirection);
        float specular = dot(normal, halfVector);
        float specularLog = 0.0;

        if (specular > 0.0)
        {
            specularLog = pow(specular, uShininess);
        }
    
        vec4 color = fragcolor;

        color.rgb *= light;

        color.rgb += specularLog;

        outColor.rgb += color.rgb;
    }

    if (uEnable[3] == 1)
    {
        vec3 surfaceToLightDirection = normalize(vSurfaceToLight[3]);
    
        vec3 halfVector = normalize(surfaceToLightDirection + surfaceToViewDirection);

        float dotFromDirection = dot(surfaceToLightDirection, -uLightDirection);
        float inLight = smoothstep(uOuterLimit, uInnerLimit, dotFromDirection);

        float light = inLight * dot(normal, surfaceToLightDirection);
        float specular = dot(normal, halfVector);
        float specularLog = 0.0;

        if (specular > 0.0)
        {
            specularLog = inLight * pow(specular, uShininess);
        }
    
        vec4 color = fragcolor;

        color.rgb *= light;

        color.rgb += specularLog;

        outColor.rgb += color.rgb;
    }
    
    gl_FragColor = outColor;
}