using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assembler
{
    class Other : Instruction
    {
        int register;
        int value;

        public Other(string line, string inslabel, int linenumber):base(line,inslabel,linenumber)
        {
            string[] operands = line.Split("\t".ToCharArray());

            opcode = operands[1];
            if (opcode == "RX")
            {
                register = int.Parse(operands[2]);
            }
            if (opcode == "TXV")
            {
                value = int.Parse(operands[2]);
            }
            if (opcode == "TXR")
            {
                register = int.Parse(operands[2]);
            }
        }
        public override int Output(Dictionary<string, int> conditionDict, Dictionary<string, int> opcodeDict)
        {
            int output = 0;

            output |= conditionDict[condition] << 28;
            output |= opcodeDict[opcode] << 23;

            if (opcode == "RX")
            {
                output |= register << 18;
            }
            if (opcode == "TXV")
            {
                output |= value << 0;
            }
            if (opcode == "TXR")
            {
                output |= register << 18;
            }
            return output;
        }
    }
}
