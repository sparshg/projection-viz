using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class Frustum : MonoBehaviour
{
    public Camera cam;
    public Material[] mat;
    public LineRenderer line;
    // public float t, t2;
    public Slider t, t2;

    void Update()
    {
        transform.position = cam.transform.position;
        transform.rotation = cam.transform.rotation;
        Vector3[] farCorners = new Vector3[4];
        cam.CalculateFrustumCorners(new Rect(0, 0, 1, 1), cam.farClipPlane, Camera.MonoOrStereoscopicEye.Mono, farCorners);
        Vector3[] nearCorners = new Vector3[4];
        cam.CalculateFrustumCorners(new Rect(0, 0, 1, 1), cam.nearClipPlane, Camera.MonoOrStereoscopicEye.Mono, nearCorners);
        line.positionCount = 16;
        line.SetPositions(new Vector3[] { farCorners[0], farCorners[1], farCorners[2], farCorners[3], farCorners[0], nearCorners[0], nearCorners[1], nearCorners[2], nearCorners[3], nearCorners[0], nearCorners[1], farCorners[1], farCorners[2], nearCorners[2], nearCorners[3], farCorners[3] });
        foreach (Material m in mat)
        {
            m.SetMatrix("_View", cam.worldToCameraMatrix);
            m.SetMatrix("_IView", cam.cameraToWorldMatrix);
            m.SetFloat("_Near", cam.nearClipPlane);
            m.SetFloat("_Far", cam.farClipPlane);
            if (t2.value == 1) t2.value = 0.999f;
            m.SetFloat("_t", t.value);
            m.SetFloat("_t2", t2.value);
        }
    }
}
