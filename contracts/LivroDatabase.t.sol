// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/LivroDatabase.sol";

contract LivroDatabaseTest is Test {
    LivroDatabase livroDatabase;

    function setUp() public {
        livroDatabase = new LivroDatabase();
    }

    function testAddAndGetLivro() public {
        livroDatabase.addLivro("12342132112das", 2024, 150, "Memorias Postumas", "Machado de Assis", 328);
        (string memory titulo, string memory autor) = livroDatabase.getLivro(0);
        assertEq(titulo, "Memorias Postumas");
        assertEq(autor, "Machado de Assis");
    }

    function testGetLivroInvalidIndex() public {
        vm.expectRevert("Indice fora dos limites");
        livroDatabase.getLivro(0);
    }

    function testAddMultipleLivros() public {
        livroDatabase.addLivro("12342132112das", 2025, 15, "Memorias de um PG", "Paulo Junior", 128);
        livroDatabase.addLivro("22342132112das", 2024, 25, "Memorias Aprofundadas", "Paulo Junior", 300);
        
        (string memory titulo1, string memory autor1) = livroDatabase.getLivro(0);
        (string memory titulo2, string memory autor2) = livroDatabase.getLivro(1);

        assertEq(titulo1, "Memorias de um PG");
        assertEq(autor1, "Paulo Junior");
        assertEq(titulo2, "Memorias Aprofundadas");
        assertEq(autor2, "Paulo Junior");
    }
}
