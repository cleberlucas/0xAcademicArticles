// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ArtigosAcademicosModel {
    struct Publicacao {
        Artigo conteudo;
        bytes32 identificacao;
        address publicador;
        uint256 timestampPublicacao;
        uint256 bloco;
        bool validado;
        address instituicao;
        string logoInstituicaoValidadora;
        string nomeInstituicaoValidadora;
    }

    struct PublicacaoResumo {
        string titulo;
        bool validado;
    }

    struct Artigo {
        string titulo;
        string resumo;
        string adicionais;
        string instituicao;
        string curso;
        string tipoDeArtigo;
        string graoAcademico;
        string urlDaDocumentacao;
        string[] autores;
        string[] orientadores;
        string[] bancaExaminadora;
        int anoDeApresentacao;
    }

    struct Instituicao {
        address conta;
        string nome;
        string urlDaLogo;
        string urlDoSite;
        string emailParaSolicitacao;
        string numeroContato;
    }
}