#include <bits/stdc++.h>
using namespace std;
typedef long long int ll;
typedef unsigned long long int ull;
#define mp make_pair
// GCD inbuilt func: __gcd(a,b)
// LCM formula: (a*b)/__gcd(a,b)

string Offset_decode(int OJ){
	int bits=16;
	string oj;
	while(bits--){
		char temp=OJ%2+'0';
		oj+=temp;
		OJ/=2;
	}
	reverse(oj.begin(),oj.end());
	return oj;
}

string Register_decode(string R){
	int n=R.size();
	int num=0,power=0;
	for(int i=n-1;i>0;i--){
		num+=(pow(10,power)*(R[i]-'0'));
		power++;
	}
	int bits=5;
	string reg="";
	while(bits--){
		char temp=num%2+'0';
		reg+=temp;
		num/=2;
	}
	reverse(reg.begin(),reg.end());
	return reg;
}

int main(){
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	// CODE goes here
    
	//////// ASSEMBLER ////////
	vector<string> machine_code;
	while(1){
		string opcode;
		cin >> opcode;
		if(opcode=="$") break;
		string command="";
		if(opcode=="ADD" || opcode=="SUB" || opcode=="AND" || opcode=="OR"){
			string Rs,Rt,Rd;
			cin >> Rd >> Rt >> Rs;
			if(opcode=="ADD") command+="000001";
			else if(opcode=="SUB") command+="000010";
			else if(opcode=="AND") command+="000100";
			else if(opcode=="OR") command+="001000";
			command+=Register_decode(Rs);
			command+=Register_decode(Rt);
			command+=Register_decode(Rd);
			command+="00000000000";
		}
		else if(opcode=="LDR" || opcode=="STR"){
			string Rs,Rt;
			int offset;
			cin >> Rt >> Rs >> offset;
			if(opcode=="LDR") command+="100001";
			else if(opcode=="STR") command+="100010";
			command+=Register_decode(Rs);
			command+=Register_decode(Rt);
			command+=Offset_decode(offset);
		}
		else if(opcode=="LDRI"){
			string Rt;
			int immediate_val;
			cin >> Rt >> immediate_val;
			command+="100100";
			command+="00000";
			command+=Register_decode(Rt);
			command+=Offset_decode(immediate_val);
		}
		else if(opcode=="JEQ" || opcode=="JNE"){
			string Rs,Rt;
			int jump_address;
			cin >> Rt >> Rs >> jump_address;
			if(opcode=="JEQ") command+="111110";
			else if(opcode=="JNE") command+="111101";
			command+=Register_decode(Rs);
			command+=Register_decode(Rt);
			command+=Offset_decode(jump_address);
		}
		else if(opcode=="EXIT") command="11111100000000000000000000000000";
		machine_code.push_back(command);
	}
	
	for(int i=0;i<machine_code.size();i++) cout << machine_code[i] << "\n";

	return 0;
}
