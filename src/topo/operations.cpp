//
// Created by marcel on 15.06.18.
//

#include "operations.h"

std::ostream& operator<<(std::ostream& os, const operation o) noexcept
{
    os << str(o);
    return os;
}

std::string str(const operation o) noexcept
{
    switch(o)
    {
        case operation::NONE:
            return "▢";
        case operation::AND:
            return "&";
        case operation::OR:
            return "|";
//            return "∥";
        case operation::NOT:
            return "¬";
        case operation::MAJ:
            return "M";
        case operation::MAJX: //JULIO
            return "MX";
        case operation::F1O2:
            return "Y";
        case operation::F2O2: //JULIO
            return "H";
        case operation::W:
            return "=";
//            return "≡";
        case operation::PI:
            return "I";
        case operation::PO:
            return "O";
        case operation::ONE:
            return "1";
        case operation::ZERO:
            return "0";
        case operation::BUF:
            return "B";
        default:
            return "X";
    }
}

std::string name_str(const operation o) noexcept
{
    switch (o)
    {
        case operation::NONE:
            return "NONE";
        case operation::AND:
            return "AND";
        case operation::OR:
            return "OR";
        case operation::NOT:
            return "NOT";
        case operation::MAJ:
            return "MAJ";
        case operation::MAJX: //JULIO
            return "MAJX";
        case operation::F1O2:
            return "F1O2";
        case operation::F1O3:
            return "F1O3";
        case operation::F2O2: //JULIO
            return "F2O2";
        case operation::XOR:
            return "XOR";
        case operation::W:
            return "WIRE";
        case operation::PI:
            return "PI";
        case operation::PO:
            return "PO";
        case operation::ONE:
            return "ONE";
        case operation::ZERO:
            return "ZERO";
        case operation::BUF:
            return "BUF";
        default:
            return "X";
    }
}
