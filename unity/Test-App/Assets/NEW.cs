using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using UnityEngine.UI;
public class NEW : MonoBehaviour
{
    public float speed = 1f;
    public GameObject DNA_curve;
    public void Update()
    {
            float sliderValue = GetComponent<Slider>().value;
            DNA_curve.transform.rotation = Quaternion.Euler(-40, sliderValue * 360,0);
            Debug.Log(sliderValue);
            Debug.Log(DNA_curve.transform.rotation);
    }
}