// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "../IAcademicArticles.sol";

pragma solidity ^0.8.23;

contract ArtigosAcademicos {
     struct Publicacao {
        Artigo conteudo;
        bytes32 identificacao;
        address publicador;
        uint256 timestampPublicacao;
        uint256 bloco;
        bool validado;
        address instituicao;
        string nomeInstituicaoValidadora;
        string logoInstituicaoValidadora;
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

    IAcademicArticles private _academicArticles;

    constructor(address academicArticlesAddress) {
        _academicArticles = IAcademicArticles(academicArticlesAddress);
    }
    
    bytes32[] private identificacaoPublicacoes;
    mapping(bytes32 identificacaoPublicacao => Publicacao) private _publicacoes;
    mapping(address conta => Instituicao) private _instituicoes;

    function PublicarArtigos(Artigo[] memory artigos) 
    public payable
    {          
        bytes32[] memory identificacaoArtigo = new bytes32[](1);
        address[] memory instituicoesValidadora= new address[](1);
        
        for (uint256 i = 0; i < artigos.length; i++) {
            identificacaoArtigo[0] = _academicArticles.PublishArticle(string(abi.encode(artigos[i])));

            instituicoesValidadora = _academicArticles.SearchArticlesInstitutionStamp(identificacaoArtigo);

            identificacaoPublicacoes.push(identificacaoArtigo[0]);

            _publicacoes[identificacaoArtigo[0]] = (Publicacao(
                artigos[i],
                identificacaoArtigo[0],
                msg.sender,
                block.timestamp,
                block.number,
                false,
                address(0),
                "",
                ""
            ));        
        }       
    }

    function DespublicarArtigos(bytes32[] memory identificacaoPublicacao) 
    public payable
    {          
        for (uint256 i = 0; i < identificacaoPublicacao.length; i++) {
            _academicArticles.UnpublishArticle(identificacaoPublicacao[0]);
        }       
    }

    function ValidarArtigos(bytes32[] memory identificacaoPublicacao) 
    public payable
    {          
        for (uint256 i = 0; i < identificacaoPublicacao.length; i++) {
            _academicArticles.ValidateArticle(identificacaoPublicacao[0]);
        }       
    }

    function DesvalidarArtigos(bytes32[] memory identificacaoPublicacao) 
    public payable
    {          
        for (uint256 i = 0; i < identificacaoPublicacao.length; i++) {
            _academicArticles.InvalidateArticle(identificacaoPublicacao[0]);
        }       
    }

    function VincularAssociado(address[] memory contaAssociados) 
    public payable
    {          
        for (uint256 i = 0; i < contaAssociados.length; i++) {
            _academicArticles.LinkAffiliate(contaAssociados[0]);
        }       
    }

    function DesvincularAssociado(address[] memory contaAssociados) 
    public payable
    {          
        for (uint256 i = 0; i < contaAssociados.length; i++) {
            _academicArticles.UnlinkAffiliate(contaAssociados[0]);
        }       
    }


    function VisualizarPublicacao(bytes32 identificacaoPublicacao) 
    public view
    returns (Publicacao memory resultado)
    {  
        address[] memory instituicoesValidadora= new address[](1);
        bytes32[] memory identificacaoArtigo = new bytes32[](1);

        resultado = _publicacoes[identificacaoPublicacao];  

        identificacaoArtigo[0] = identificacaoPublicacao;

        instituicoesValidadora = _academicArticles.SearchArticlesInstitutionStamp(identificacaoArtigo);

        resultado = Publicacao(
                resultado.conteudo,
                resultado.identificacao,
                resultado.publicador,
                resultado.timestampPublicacao,
                resultado.bloco,
                instituicoesValidadora[0] != address(0),
                instituicoesValidadora[0],
                instituicoesValidadora[0] != address(0)? _instituicoes[instituicoesValidadora[0]].nome : "",
                instituicoesValidadora[0] != address(0)? _instituicoes[instituicoesValidadora[0]].urlDaLogo : ""
            );            
    }

    function VisualizarResumoPublicacoes(uint256 indiceInicial, uint256 indiceFinal) 
    public view
    returns (PublicacaoResumo[] memory resultado, uint256 tamanhoAtual)
    {          
        tamanhoAtual = identificacaoPublicacoes.length;

        if (indiceInicial >= tamanhoAtual || indiceInicial > indiceFinal) {
            resultado = new PublicacaoResumo[](0);
        }
        else {
            address[] memory instituicoesValidadora= new address[](1);
            bytes32[] memory identificacaoArtigo = new bytes32[](1);

            uint256 contagem = indiceFinal - indiceInicial + 1;
            uint256 contagemAtual = (contagem <= tamanhoAtual - indiceInicial) ? contagem : tamanhoAtual - indiceInicial;

            resultado = new PublicacaoResumo[](contagemAtual);

            for (uint256 i = 0; i < contagemAtual; i++) {
                identificacaoArtigo[0] = identificacaoArtigo[indiceInicial + i];
                instituicoesValidadora = _academicArticles.SearchArticlesInstitutionStamp(identificacaoArtigo);

                resultado[i] = PublicacaoResumo(
                    _publicacoes[identificacaoPublicacoes[indiceInicial + i]].conteudo.titulo,
                    instituicoesValidadora[0] != address(0)
                );
            }
        }      
    }
}
