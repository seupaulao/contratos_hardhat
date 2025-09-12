// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

struct Livro {
    string  isbn;
    uint16  ano;
    uint256  preco;
    string  titulo;
    string  autor;
    uint16 paginas;

}

contract LivroDatabase {
    Livro[] public livros;

    function getLivro(uint256 index) public view returns (string memory, string memory) {
        if (index >= livros.length) revert("Indice fora dos limites");
        Livro memory livroselecionado = livros[index];
        return (livroselecionado.titulo, livroselecionado.autor);
    }

    function addLivro(string memory _isbn, uint16 _ano, uint256 _preco, string memory _titulo, string memory _autor, uint16 _paginas) public {
        livros.push(Livro({
            isbn: _isbn,
            ano: _ano,
            preco: _preco,
            titulo: _titulo,
            autor: _autor,
            paginas: _paginas
        }));
    }

    function updateLivro(uint256 index, string memory _isbn, uint16 _ano, uint256 _preco, string memory _titulo, string memory _autor, uint16 _paginas) public {
        if (index >= livros.length) revert("Livro nao encontrado");
        Livro memory livroselecionado = livros[index];

        if (bytes(_isbn).length >= 0) {
            livroselecionado.isbn = _isbn;
        }
        if (_ano >= 0) {
            livroselecionado.ano = _ano;
        }
        if (_preco >= 0) {
            livroselecionado.preco = _preco;
        }
        if (bytes(_titulo).length >= 0) {
            livroselecionado.titulo = _titulo;
        }
        if (bytes(_autor).length >= 0) {
            livroselecionado.autor = _autor;
        } 

        livroselecionado.paginas = _paginas;

        livros[index] = livroselecionado;
    }

    function deleteLivro(uint256 index) public {
         delete livros[index];
    }
}
