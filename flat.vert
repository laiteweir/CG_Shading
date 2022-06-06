attribute vec3 aVertexPosition;
attribute vec3 aFrontColor;

uniform vec3 uLightWorldPosition[4];
uniform vec3 uViewWorldPosition;

uniform mat4 uWorld;
uniform mat4 uWorldInverseTranspose;
uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

varying vec4 fragcolor;
varying vec3 surfaceWorldPosition;
varying vec3 vSurfaceToLight[4];
varying vec3 vSurfaceToView;

void main(void)
{
    fragcolor = vec4(aFrontColor.rgb, 1.0);

    gl_Position = uPMatrix * uMVMatrix * uWorld * vec4(aVertexPosition, 1.0);

    surfaceWorldPosition = (uWorld * vec4(aVertexPosition, 1.0)).xyz;

    for (int i = 0; i < 4; ++i)
    {
        vSurfaceToLight[i] = uLightWorldPosition[i] - surfaceWorldPosition;
    }

    vSurfaceToView = uViewWorldPosition - surfaceWorldPosition;
}