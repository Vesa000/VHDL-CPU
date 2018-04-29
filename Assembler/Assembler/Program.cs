using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Assembler
{
    class Program
    {
        public static string[] InstructionOpcodes = { "LDV", "LDR", "STR", "MOV", "LDM", "STM", "JMP", "BRA", "RET", "ADD", "SUB", "MUL", "DIV", "CMP", "CMPU", "SHL", "SHR", "AND", "OR", "INV", "XOR", "NAND", "NOR", "XNOR", "REB", "NOP", "HLT" };
        public static string[] moveOpcodes = { "LDV", "LDR", "STR", "MOV"};
        public static string[] jumpOpcodes = { "JMP", "BRA", "RET" };
        public static string[] arithmeticOpcodes = { "ADD", "SUB", "MUL", "DIV", "CMP", "CMPU", "SHL", "SHR", "AND", "OR", "INV", "XOR", "NAND", "NOR", "XNOR" };
        public static string[] otherOpcodes = { "NOP", "HLT" };

        public static int conditionOffset = 28;
        public static int opcodeOffset = 23;
        public static int registerAOffset = 18;
        public static int registerBOffset = 13;
        public static int registerQOffset = 8;
        public static int pcOffset = 0;
        public static int valueOffset = 0;
        public static int addressOffset = 0;
        public static int alunstructionOffset = 0;

        public static int ramSize = 30000;

        static void Main(string[] args)
        {
            string currentDir = Environment.CurrentDirectory;
            string inputFolder = currentDir + "\\Input";
            string[] filePaths = Directory.GetFiles(inputFolder);
            string outPath = currentDir + "\\Output";

            #region Dictionaries
            Dictionary<string, int> opcodeDict = new Dictionary<string, int>
            {
                { "LDV", 1 },
                { "LDR", 2 },
                { "STR", 3 },
                { "MOV", 4 },
                { "JMP", 7 },
                { "BRA", 8 },
                { "RET", 9 },
                { "ALU", 10 },
                { "NOP", 0  },
                { "HLT", 31 }
            };
            Dictionary<string, int> conditionDict = new Dictionary<string, int>
            {
                { "ALW", 0 },
                { "EQ", 1 },
                { "NEQ", 2 },
                { "GT", 3 },
                { "GEQ", 4 },
                { "LT", 5 },
                { "LEQ", 6 },
                { "TX", 7 },
                { "RX", 8 },
                { "NOP", 15 }
            };
            Dictionary<string, int> aluDict = new Dictionary<string, int>
            {
                {"ADD",0 },
                {"SUB",1 },
                {"MUL",2 },
                {"DIV",3 },
                {"CMP",4 },
                {"CMPU",5 },
                {"SHL",6 },
                {"SHR",7 },
                {"AND",8 },
                {"OR",9 },
                {"INV",10 },
                {"XOR",11 },
                {"NAND",12 },
                {"NOR",13 },
                {"XNOR",14 },
            };
            #endregion

            foreach (string filePath in filePaths)
            {
                StreamReader sr = new StreamReader(filePath);
                string assembly = sr.ReadToEnd();
                sr.Close();

                //split lines
                List<Instruction> instructions = new List<Instruction>();
                string[] lines = assembly.Split("\r\n".ToCharArray());
                string label = "";
                for (int i = 0; i < lines.Length; i++)
                {
                    //remove comments
                    if (lines[i].Contains("//"))
                    {
                        lines[i] = lines[i].Substring(0, lines[i].IndexOf("//"));
                    }

                    //Line is label
                    if (lines[i].Contains(":"))
                    {
                        label = lines[i].Substring(0, lines[i].IndexOf(':'));
                    }
                    
                    //Line is instruction
                    else if (Isinside(lines[i], InstructionOpcodes))
                    {
                        if (Isinside(lines[i], moveOpcodes))
                            instructions.Add(new Move(lines[i], label, i));

                        if (Isinside(lines[i], jumpOpcodes))
                            instructions.Add(new Jump(lines[i], label, i));

                        if (Isinside(lines[i], arithmeticOpcodes))
                            instructions.Add(new Arithmetic(lines[i], label, i, aluDict));

                        if (Isinside(lines[i], otherOpcodes))
                            instructions.Add(new Other(lines[i], label, i));

                        label = "";
                    }
                }

                //output hex
                StreamWriter sw = new StreamWriter(outPath + "\\" + filePath.Substring(inputFolder.Length)+".data");
                StreamWriter swText = new StreamWriter(outPath + "\\" + filePath.Substring(inputFolder.Length) + ".txt");

                for (int i = 0; i < instructions.Count; i++)
                {
                    string str;
                    if (instructions[i] is Jump)
                        str = Convert.ToString(((Jump)instructions[i]).Output(conditionDict, opcodeDict, instructions), 2).PadLeft(32, '0');

                    else
                        str = Convert.ToString(instructions[i].Output(conditionDict, opcodeDict), 2).PadLeft(32, '0');

                    sw.WriteLine(str);
                    swText.WriteLine(instructions[i].opcode);
                }
                for (int i = instructions.Count; i < ramSize; i++)
                {
                    sw.WriteLine(Convert.ToString(0, 2).PadLeft(32,'0'));
                }
                sw.Close();
                swText.Close();
            }
            Console.WriteLine("Done");
            Console.ReadKey();
        }

        public static bool Isinside(string s, string[] strings)
        {
            string[] operands = s.Split("\t".ToCharArray());
            if (operands.Count() > 1)
            {
                foreach (string str in strings)
                {
                    if (operands[1] == str)

                        return true;
                }
            }
            return false;
        }
    }
}
