import std.stdio;
import std.process;
import std.range;
import std.array;
import std.string;
import std.algorithm;

int main(string[] args)
{
	uint[][] grid;
	auto input = args.length > 1 ? File(args[1]) : stdin;
	foreach(row; input.byLine)
		grid ~= row.chomp.map!(c => c == ' ' ? 0 : c - '0').array;
	auto sudoku = Solver(grid);
	writeln(sudoku.solve);
	return 0;
}

struct Solver
{
	uint[][] grid;

	bool solve()
	{
		system("cls");
		display();
		int r, c;
		bool done = nextEmptyCell(r, c);
		if(done)
			return true;
		foreach(digit; 1 .. 10)
		{
			if(surrounding(r, c).canFind(digit))
				continue;
			if(column(c).canFind(digit))
				continue;
			if(row(r).canFind(digit))
				continue;
			grid[r][c] = digit;
			if(solve())
				return true;
			grid[r][c] = 0;
		}
		return false;
	}

	uint[] surrounding(int row, int col)
	{
		uint[] result;
		int rmin, rmax, cmin, cmax;
		bounds(row, rmin, rmax);
		bounds(col, cmin, cmax);
		foreach(r; rmin .. rmax)
			foreach(c; cmin .. cmax)
				if(r != row || c != col)
					result ~= grid[r][c];
		return result;
	}

	auto column(int col)
	{
		return grid.map!(row => row[col]);
	}

	uint[] row(int row)
	{
		return grid[row];
	}

	void display()
	{
		foreach(row; grid)
		{
			foreach(cell; row)
			{
				if(cell == 0)
					write(" ");
				else
					write(cell);
				write(" ");
			}
			writeln;
		}
	}

	private:
	void bounds(int value, ref int min, ref int max)
	{
		if(value < 3)
		{
			min = 0;
			max = 3;
		}
		else if(value < 6)
		{
			min = 3;
			max = 6;
		}
		else
		{
			min = 6;
			max = 9;
		}
	}

	bool nextEmptyCell(ref int row, ref int col)
	{
		foreach(r; 0 .. grid.length)
		{
			foreach(c; 0 .. grid[0].length)
			{
				if(grid[r][c] == 0)
				{
					row = r;
					col = c;
					return false;
				}
			}
		}
		return true;
	}
}


unittest
{
	uint[][] grid;
	foreach(i; 0 .. 9)
		grid ~= iota(1u, 10u).array;
	auto sudoku = Solver(grid);
	assert(sudoku.column(3).equal([4, 4, 4, 4, 4, 4, 4, 4, 4]));
	assert(sudoku.column(6).equal([7, 7, 7, 7, 7, 7, 7, 7, 7]));
	assert(sudoku.row(6) == [1, 2, 3, 4, 5, 6, 7, 8, 9]);
	assert(sudoku.row(8) == [1, 2, 3, 4, 5, 6, 7, 8, 9]);
	assert(sudoku.surrounding(0, 0) == [2, 3, 1, 2, 3, 1, 2, 3]);
	assert(sudoku.surrounding(8, 8) == [7, 8, 9, 7, 8, 9, 7, 8]);
	assert(sudoku.surrounding(3, 3) == [5, 6, 4, 5, 6, 4, 5, 6]);
}

