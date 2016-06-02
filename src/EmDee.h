typedef struct {
  void *data;
  void *params;
} md_model;

typedef struct {

  int builds;            // Number of neighbor-list builds
  double time;           // Total time taken in force calculations
  double Rc;             // Cut-off distance
  double RcSq;           // Cut-off distance squared
  double xRc;            // Extended cutoff distance (including skin)
  double xRcSq;          // Extended cutoff distance squared
  double skinSq;         // Square of the neighbor list skin width

  int mcells;            // Number of cells at each dimension
  int ncells;            // Total number of cells
  int maxcells;          // Maximum number of cells
  int maxatoms;
  int maxpairs;          // Maximum number of pairs containing all atoms of a cell
  void *cell;            // Array containing all neighbor cells of each cell

  int natoms;            // Number of atoms in the system
  int *type;             // The type of each atom
  double *R0;            // The position of each atom at the latest neighbor list building
  double *charge;        // Pointer to the electric charge of each atom

  int ntypes;            // Number of atom types
  void *pairType;        // Model and parameters of each type of atom pair
 
  void *bond;            // List of bonds
  void *angle;           // List of angles
  void *dihedral;        // List of dihedrals

  double Energy;         // Total potential energy of the system
  double Virial;         // Total internal virial of the system

  int nthreads;          // Number of parallel openmp threads
  void *cellAtom;        // List of atoms belonging to each cell
  void *threadCell;      // List of cells to be dealt with in each parallel thread
  void *neighbor;        // Pointer to neighbor lists
  void *excluded;        // List of pairs excluded from the neighbor lists

} tEmDee;

tEmDee md_system( int threads, double rc, double skin, int N, int *types );

void md_set_charges( tEmDee *md, double *charges );

void md_set_pair( tEmDee *md, int itype, int jtype, md_model *model );

void md_add_bond( tEmDee *md, int i, int j, md_model *model );

void md_add_angle( tEmDee *md, int i, int j, int k, md_model *model );

void md_add_dihedral( tEmDee *md, int i, int j, int k, int l, md_model *model );

void md_exclude_pair( tEmDee *md, int i, int j );

void md_compute_forces( tEmDee *md, double *forces, double *coords, double L );

md_model pair_lj( double sigma, double epsilon );

md_model pair_lj_sf( double sigma, double epsilon, double cutoff );

md_model pair_lj_coul_sf( double sigma, double epsilon, double permittivity, double cutoff );

md_model bond_harmonic( double k, double r0 );

md_model bond_morse( double D, double alpha, double r0 );

md_model angle_harmonic( double k, double theta0 );

md_model dihedral_harmonic( double k, double phi0 );

