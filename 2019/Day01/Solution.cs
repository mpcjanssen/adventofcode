using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Text.RegularExpressions;
using System.Text;
using System.Threading;
using Microsoft.CodeAnalysis.VisualBasic.Syntax;

namespace AdventOfCode.Y2019.Day01 {

    class Solution : Solver {

        public string GetName() => "The Tyranny of the Rocket Equation";

        public IEnumerable<object> Solve(string input)
        {
            var masses = input.Split("\n").Select(x => Int64.Parse(x));
            yield return PartOne(masses);
            yield return PartTwo(masses);
        }

        long PartOne(IEnumerable<long> input) {
            return input.Select(x=> x/3 -2).Sum();
        }

        IEnumerable<Int64> Fuels(Int64 mass)
        {
            var fuel = mass;
            while (true)
            {
                fuel = fuel / 3 - 2;
                \\
            }
        }
        long PartTwo(IEnumerable<long> input) {
            return input.Select(x=> Fuels(x).TakeWhile(y=> y > 0).Sum()).Sum();
        }
    }
}