using System;
using System.Collections;
using System.Collections.Generic;
using MoreMountains.Tools;
using UnityEngine;

[RequireComponent(typeof(CircleCollider2D),typeof(Rigidbody2D))]
public class BaseReflectibleMissile : MonoBehaviour
{
  
  public LayerMask ReflectLayer = new LayerMask();
  public event Action onReflectEvent;
  private Vector2 velocity;
  private Rigidbody2D myRigibody;
  

 
  private void Awake()
  {
    myRigibody = GetComponent<Rigidbody2D>();
    myRigibody.gravityScale = 0;
    myRigibody.freezeRotation = true;
    myRigibody.angularDrag = 0;
  }

 public void SetMissileVelocity(Vector2 setVelocity)
  {
    myRigibody.velocity = setVelocity;
    velocity = setVelocity;
  }

  private void OnCollisionEnter2D(Collision2D collision)
  {
    if ( ((ReflectLayer.value & (1 << collision.gameObject.layer))) > 0)
    {
      velocity = velocity-2*Vector2.Dot(velocity, collision.contacts[0].normal)*collision.contacts[0].normal;
      myRigibody.velocity = velocity;
      
      if (onReflectEvent!=null)
      {
        onReflectEvent();
      }

    }
  }


}
