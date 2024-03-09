using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CamMove : MonoBehaviour
{

    public Slider t1, t2;
    Vector3 initPos;
    Quaternion initRot;

    void Start()
    {
        initPos = transform.position;
        initRot = transform.rotation;
    }
    void Update()
    {
        transform.position = Vector3.Lerp(initPos, Vector3.zero, t1.value);
        transform.rotation = Quaternion.Lerp(initRot, Quaternion.identity, t2.value);
    }

}
