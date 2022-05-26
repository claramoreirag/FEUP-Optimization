/*********************************************
 * OPL 22.1.0.0 Model
 * Author: clara
 * Creation Date: 12 May 2022 at 10:33:41
 *********************************************/
{string} Classes=...;
{string} Teachers=...;

int CoursePreferences[Teachers][Classes]=...;
int CourseLoad[Teachers]=...;
int Seniority[Teachers]=...;
int InstructorsQualifications[Teachers][Classes]=...;

dvar boolean  x[Teachers][Classes]; //course-teacher associations

//aux dvars
dvar int CS03teaching;
dvar int Preparations[Teachers];
dvar int AuxPrep;
dvar int SumSeniority;
maximize SumSeniority - 10*CS03teaching - 10*AuxPrep;

subject to{
  forall (i in Teachers){
    forall (j in Classes){
      InstructorsQualifications[i][j]>=x[i][j];
    }
  }
  
  forall (i in Teachers){
    sum (j in Classes) x[i][j]==CourseLoad[i];
  }
  
  forall (j in Classes){
	  sum (i in Teachers) x[i][j]==1;
  }
  
  CS03teaching == (sum (i in Teachers) (x[i]["CS031"]+x[i]["CS032"]+x[i]["CS033"]+x[i]["CS034"]+x[i]["CS035"]>=3));
  
  forall(i in Teachers){
    Preparations[i]==  ((x[i]["CS031"]+x[i]["CS032"]+x[i]["CS033"]+x[i]["CS034"]+x[i]["CS035"])>=1)+
     ((x[i]["CS021"]+x[i]["CS022"]+x[i]["CS023"]+x[i]["CS024"]+x[i]["CS025"]+x[i]["CS026"])>=1)+
     ((x[i]["CS011"]+x[i]["CS012"])>=1)+
     ((x[i]["CS021"]+x[i]["CS022"]+x[i]["CS023"]+x[i]["CS024"]+x[i]["CS025"]+x[i]["CS026"])>=1)+
     ((x[i]["CS041"]+x[i]["CS051"])>=1)+
     ((x[i]["CS061"]+x[i]["CS062"]+x[i]["CS063"]+x[i]["CS064"]+x[i]["CS065"]+x[i]["CS066"])>=1);
  }
  
   AuxPrep==sum(i in Teachers)(Preparations[i]>=3);
   SumSeniority ==sum(i in Teachers) sum(j in Classes)Seniority[i]*x[i][j]*CoursePreferences[i][j];
   
 
   
}