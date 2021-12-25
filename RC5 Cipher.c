/*
 * GccApplication1.c
 *
 * Created: 5/9/2020 4:26:36 AM
 * Author : abdulrahmanhussien
 */ 

#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
    unsigned int K[] = {0x7C7C, 0x8282, 0x8787 ,0x8B8B,0x8E8E,0x9090 } ;
	unsigned int a = 0xF2A1; //input A 
	unsigned int b = 0xFC23; //input B 
	unsigned int a1; //input A 
	unsigned int b1; //input B 
	unsigned int output[] = {0,0};
	//Second Step: 
	unsigned int P = 0xB7E1 ;
	unsigned int Q = 0x9E37;
	unsigned int S[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; //initiate S 
	S[0] = P; // 
	unsigned int x ; 
	for (x=1; x <=18; x++ ){
		S[x]= S[x-1] + Q ; 
		
	}
	unsigned int i = 0 ; 
	unsigned int j =0 ; 
	unsigned int A = 0 ;
	unsigned int B =0 ;
	unsigned int AB =0 ;
	unsigned int y ;
	unsigned int temp1 ;
	
	
	for (x=1; x <=54; x++ ){
		A=(S[i]+A+B) ;
		
		
		//Rotating 
		for (y=1; y <=3; y++ ){
			if (A & (1<<15)){
				(A=A<<1) ;
				 A|=1 ;
			}else{
			 (A=A<<1) ; 
			}
			}
		
		S[i]=A;
		AB= A+B;
		AB&=0x000F;
		B= (K[j]+ A + B) ;
		
		
		//Rotating 
		for (y=1; y <=AB; y++ ){
			if (B & (1 << 15)){
				(B=B<<1);
				B|=1;
			}else{
				(B=B<<1) ;
			}
			}
			K[j]=B;
	i = (i + 1) % 18;
	j = (j+1) % 6;
	
			}
	//

	
	
	
	
	//************************************************************// 
	//Encryption 
	
	a=a+S[0];
	b= b +S[1];
	for (i=1 ; i <= 8; ++i){
		a=(a^b);
		AB=b ;
		AB&=0x000F;
		//Rotation 
		for (y=1; y <=AB; ++y ){
			if (a & (1 << 15)){
				a= (a <<1);
				a|=1;
			}else{
				a= (a<<1) ;
			}
		}
		//END ROTATION 
		a=a+S[(2*i)];
		AB=a ;
		b=a^b;
		
		// ROTATION
		AB&=0x000F;
		for (y=1; y <=AB; ++y ){
			if (b & (1 << 15)){
			b= (b <<1);
			b|=1;
			}
			else{
				b=(b<<1) ;
			
			}
		//END ROTATION 

		}
		
		b=b+S[(2*i)+1];
		}
		printf("%d %d",a,b); // Monitoring
	//************************************************************// 
	//Decryption 
	
	
	for (i=8; i>=1 ;i--){
		b=(b-S[(2*i)+1]);
		AB=a; 
		
		// ROTATION 
		AB&=0x000F; //Masking
		for (y=1; y <=AB; ++y ){
			if (b & (1)){
			b=(b>>1);
			b|=(1<<15);
			}else{
			b=(b>>1) ;
			}
		}
		//END ROTATION 

		b^=a;
		
		a=(a-S[2*i]); 
		AB=b; 
		//ROTATION 
		AB&=0x000F; 		
		for (y=1; y <=AB; ++y ){
			if (a & (1)){
			a=(a >>1);
			a|=(1<<15);
			}else{
			a=(a>>1) ;
			}
		}
		a^=b;
		}
		//END ROTATION 
		
		
		b=b-S[1];
		a=a-S[0];
		
		output[0]=a; 
		output[1]=b;
		printf("%d %d",a,b); //Tranking A,B 
		printf("%d %d",a,b); // Due to Atmel Optimization, i had to put these lines to monitor
							// variables since it was optimized away. 	
		
}

