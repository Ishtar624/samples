#include <string>
#include <random>
using namespace std;

void generate_array(int quan, int range_min, int range_max)
{
	std::random_device rd;     // initialise seed engine
	std::mt19937 rng(rd());    // random-number engine: Mersenne-Twister
	std::uniform_int_distribution<int> uni(range_min, range_max);

	FILE*f = fopen("test.txt", "w");
	for(int i=0 ; i<quan ; i++)
		fprintf(f, "%d ", uni(rng));
	fclose(f);
}

void Simple_Merging_Sort(char *name) {
	int a1, a2, k, i, j, length, tmp;
	FILE *f, *f1, *f2, *f_original;
	length = 0;
	f = fopen("smsorted.txt", "w");
	if ((f_original = fopen(name, "r")) == NULL)
		printf("\nNo file\n");
	else {
		while (!feof(f_original)) {
			fscanf(f_original, "%d", &a1);
			fprintf(f, "%d ", a1);
			length++;
		}
		fclose(f);
	}
	fclose(f_original);
	k = 1;
	while (k < length) {
		f = fopen("smsorted.txt", "r");
		string name1 = "smsort";
		name1 = name1 + to_string(k);
		string name2 = name1 + "_2.txt";
		name1 = name1 + "_1.txt";
		f1 = fopen(name1.c_str(), "w");
		f2 = fopen(name2.c_str(), "w");
		if (!feof(f)) fscanf(f, "%d", &a1);
		while (!feof(f)) {
			for (i = 0; i < k && !feof(f); i++) {
				fprintf(f1, "%d ", a1);
				fscanf(f, "%d", &a1);
			}
			for (j = 0; j < k && !feof(f); j++) {
				fprintf(f2, "%d ", a1);
				fscanf(f, "%d", &a1);
			}
		}
		fclose(f2);
		fclose(f1);
		fclose(f);

		f = fopen("smsorted.txt", "w");
		f1 = fopen(name1.c_str(), "r");
		f2 = fopen(name2.c_str(), "r");
		if (!feof(f1)) fscanf(f1, "%d", &a1);
		if (!feof(f2)) fscanf(f2, "%d", &a2);
		while (!feof(f1) && !feof(f2)) {
			i = 0;
			j = 0;
			while (i < k && j < k && !feof(f1) && !feof(f2)) {
				if (a1 < a2) {
					fprintf(f, "%d ", a1);
					fscanf(f1, "%d", &a1);
					i++;
				}
				else {
					fprintf(f, "%d ", a2);
					fscanf(f2, "%d", &a2);
					j++;
				}
			}
			while (i < k && !feof(f1)) {
				fprintf(f, "%d ", a1);
				fscanf(f1, "%d", &a1);
				i++;
			}
			while (j < k && !feof(f2)) {
				fprintf(f, "%d ", a2);
				fscanf(f2, "%d", &a2);
				j++;
			}
		}
		while (!feof(f1)) {
			fprintf(f, "%d ", a1);
			fscanf(f1, "%d", &a1);
		}
		while (!feof(f2)) {
			fprintf(f, "%d ", a2);
			fscanf(f2, "%d", &a2);
		}
		fclose(f2);
		fclose(f1);
		fclose(f);
		k = k * 2;
	}
	//remove("smsort_1.txt");
	//remove("smsort_2.txt");
}
int main()
{
	generate_array(1000, 0, 99);
	Simple_Merging_Sort("test.txt");
	return 0;
}

