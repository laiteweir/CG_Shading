attribute vec3 aVertexPosition;
attribute vec3 aFrontColor;
attribute vec3 aNormal;

uniform float uShininess;

uniform vec3 uLightWorldPosition[4];
uniform int uEnable[4];
uniform float uInnerLimit;
uniform float uOuterLimit;
uniform vec3 uLightDirection;
uniform vec3 uViewWorldPosition;
    
uniform mat4 uWorld;
uniform mat4 uWorldInverseTranspose;
uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

varying vec4 fragcolor;

void main(void)
{
    gl_Position = uPMatrix * uMVMatrix * uWorld * vec4(aVertexPosition, 1.0);

    vec3 normal = normalize((uWorldInverseTranspose * vec4(aNormal, 0)).xyz);

    vec3 surfaceWorldPosition = (uWorld * vec4(aVertexPosition, 1.0)).xyz;

    vec3 surfaceToViewDirection = normalize(uViewWorldPosition - surfaceWorldPosition);

    vec4 outColor = vec4(0, 0, 0, 1);

    for (int i = 0; i < 3; ++i)
    {
        if (uEnable[i] == 0)
        {
            continue;
        }

        vec3 surfaceToLightDirection = normalize(uLightWorldPosition[i] - surfaceWorldPosition);

        vec3 halfVector = normalize(surfaceToLightDirection + surfaceToViewDirection);

        float light = dot(normal, surfaceToLightDirection);
        float specular = dot(normal, halfVector);
        float specularLog = 0.0;

        if (specular > 0.0)
        {
            specularLog = pow(specular, uShininess);
        }
    
        vec4 color = vec4(aFrontColor.rgb, 1.0);

        color.rgb *= light;

        color.rgb += specularLog;

        outColor.rgb += color.rgb;
    }

    if (uEnable[3] == 1)
    {
        vec3 surfaceToLightDirection = normalize(uLightWorldPosition[3] - surfaceWorldPosition);
    
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
    
        vec4 color = vec4(aFrontColor.rgb, 1.0);

        color.rgb *= light;

        color.rgb += specularLog;

        outColor.rgb += color.rgb;
    }

    fragcolor = outColor;
}