using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class CamMove : MonoBehaviour
{

    public Slider t1, t2;
    Vector3 initPos;
    Quaternion initRot;

    public GameObject[] gameObjects;

    void Start()
    {
        initPos = transform.position;
        initRot = transform.rotation;
    }
    void Update()
    {
        transform.position = Vector3.Lerp(initPos, Vector3.zero, t1.value);
        transform.rotation = Quaternion.Lerp(initRot, Quaternion.identity, t2.value);
        if (Input.GetKeyDown(KeyCode.P))
        {
            foreach (GameObject g in gameObjects)
            {
                g.SetActive(!g.activeSelf);
            }
        }
    }
       

}
