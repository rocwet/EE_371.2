// This is a program that calculates int multiplication with their pointers
int main(int argc, char ** argv){
  int A = 22;
  int B = 17;
  int C = 6;
  int D = 4;
  int E = 9;
  int result;
  int * A_ptr = &A;
  int * B_ptr = &B;
  int * C_ptr = &C;
  int * D_ptr = &D;
  int * E_ptr = &E;

  result = ((*A_ptr - *B_ptr) * (*C_ptr + *D_ptr))/ *E_ptr;
  printf("The result is : %d\n", result);
  
  return 0;
}
