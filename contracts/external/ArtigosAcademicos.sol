// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "../IAcademicArticles.sol";
import "../AcademicArticlesMessage.sol";

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
        address[] contasAfiliados;
        bytes32[] identificacoesArtigosValidados;
    }

    struct ModeloDados {
        bytes32[] identificacoesArtigosPublicacao;
        mapping(bytes32 identificacaoArtigo => Publicacao) publicacao;
        address[] contasInstituicoes;
        mapping(address conta => Instituicao) instituicao;
        bytes32[] identificacoesArtigosValidados;  
    }

    event ArtigoPublicado(bytes32 indexed identificacaoArtigo);
    event ArtigoDespublicado(bytes32 indexed identificacaoArtigo);
    event ArtigoValidado(bytes32 indexed identificacaoArtigo);
    event ArtigoDesvalidado(bytes32 indexed identificacaoArtigo);
    event AfiliadoVinculado(address indexed contaAfiliado);
    event AfiliadoDesvinculado(address indexed contaAfiliado);

    constructor(address academicArticlesAddress) {
        _academicArticles = IAcademicArticles(academicArticlesAddress);
    }

    IAcademicArticles private _academicArticles;

    ModeloDados private _dados;

    function PublicarArtigos(Artigo[] memory artigos) 
    public payable {          
        bytes32[] memory identificacaoArtigoEscrita = new bytes32[](1);
        address[] memory instituicoesValidadoraConsulta = new address[](1);
        
        for (uint256 i = 0; i < artigos.length; i++) {
            identificacaoArtigoEscrita[0] = _academicArticles.PublishArticle(string(abi.encode(artigos[i])));

            instituicoesValidadoraConsulta = _academicArticles.ArticleInstitutionStamp(identificacaoArtigoEscrita);

            _dados.identificacoesArtigosPublicacao.push(identificacaoArtigoEscrita[0]);

            _dados.publicacao[identificacaoArtigoEscrita[0]] = (Publicacao(
                artigos[i],
                identificacaoArtigoEscrita[0],
                tx.origin,
                block.timestamp,
                block.number,
                false,
                address(0),
                "",
                ""
            ));

            emit ArtigoPublicado(identificacaoArtigoEscrita[0]);      
        }       
    }

    function DespublicarArtigos(bytes32[] memory identificacoesArtigos)
    public payable {          
        for (uint256 i = 0; i < identificacoesArtigos.length; i++) {
            for (uint256 ii = 0; ii < _dados.identificacoesArtigosPublicacao.length; ii++) {
                if (_dados.identificacoesArtigosPublicacao[ii] == identificacoesArtigos[i]) {    

                    try _academicArticles.UnpublishArticle(identificacoesArtigos[i]) {                      
                    } catch Error(string memory erro) {
                        if (keccak256(abi.encodePacked(erro)) != keccak256(abi.encodePacked(AcademicArticlesMessage.ARTICLE_WAS_NOT_PUBLISHED))) {
                            revert(erro);
                        }
                    } 

                    _dados.identificacoesArtigosPublicacao[ii] = _dados.identificacoesArtigosPublicacao[_dados.identificacoesArtigosPublicacao.length - 1];
                    _dados.identificacoesArtigosPublicacao.pop();

                    emit ArtigoDespublicado(identificacoesArtigos[i]);
                }
            }
        }     
    }

    //Criar o criar instituição
   
    function ValidarArtigos(bytes32[] memory identificacaoArtigo) 
    public payable {          
        for (uint256 i = 0; i < identificacaoArtigo.length; i++) {
            _academicArticles.StampArticle(identificacaoArtigo[i]);
            emit ArtigoValidado(identificacaoArtigo[i]);
        }       
    }

    function DesvalidarArtigos(bytes32[] memory identificacaoArtigo) 
    public payable {          
        for (uint256 i = 0; i < identificacaoArtigo.length; i++) {
            _academicArticles.UnstampArticle(identificacaoArtigo[i]);
            emit ArtigoDesvalidado(identificacaoArtigo[i]);
        }       
    }

    function VincularAssociado(address[] memory contaAssociados) 
    public payable {          
        for (uint256 i = 0; i < contaAssociados.length; i++) {
            _academicArticles.LinkAffiliate(contaAssociados[0]);
        }       
    }

    function DesvincularAssociado(address[] memory contaAssociados) 
    public payable {          
        for (uint256 i = 0; i < contaAssociados.length; i++) {
            _academicArticles.UnlinkAffiliate(contaAssociados[0]);
        }       
    }

    function VisualizarPublicacao(bytes32 identificacaoArtigo) 
    public view
    returns (Publicacao memory resultado) {  
        address[] memory instituicoesValidadoraConsulta = new address[](1);
        bytes32[] memory identificacaoArtigoConsulta = new bytes32[](1);

        resultado = _dados.publicacao[identificacaoArtigo];  

        identificacaoArtigoConsulta[0] = identificacaoArtigo;

        instituicoesValidadoraConsulta = _academicArticles.ArticleInstitutionStamp(identificacaoArtigoConsulta);

        resultado = Publicacao(
                resultado.conteudo,
                resultado.identificacao,
                resultado.publicador,
                resultado.timestampPublicacao,
                resultado.bloco,
                instituicoesValidadoraConsulta[0] != address(0),
                instituicoesValidadoraConsulta[0],
                instituicoesValidadoraConsulta[0] != address(0)? _dados.instituicao[instituicoesValidadoraConsulta[0]].nome : "",
                instituicoesValidadoraConsulta[0] != address(0)? _dados.instituicao[instituicoesValidadoraConsulta[0]].urlDaLogo : ""
            );            
    }

    function VisualizarResumoPublicacoes(uint256 indiceInicial, uint256 indiceFinal) 
    public view
    returns (PublicacaoResumo[] memory resultado, uint256 tamanhoAtual) {          
        tamanhoAtual = _dados.identificacoesArtigosPublicacao.length;

        if (indiceInicial >= tamanhoAtual || indiceInicial > indiceFinal) {
            resultado = new PublicacaoResumo[](0);
        }
        else {
            address[] memory instituicoesValidadoraConsulta = new address[](1);
            bytes32[] memory identificacaoArtigoConsulta  = new bytes32[](1);

            uint256 tamanho = indiceFinal - indiceInicial + 1;
            uint256 tamanhoCorrigido = (tamanho <= tamanhoAtual - indiceInicial) ? tamanho : tamanhoAtual - indiceInicial;

            resultado = new PublicacaoResumo[](tamanhoCorrigido);

            for (uint256 i = 0; i < tamanhoCorrigido; i++) {
                identificacaoArtigoConsulta [0] = identificacaoArtigoConsulta [indiceInicial + i];
                instituicoesValidadoraConsulta  = _academicArticles.ArticleInstitutionStamp(identificacaoArtigoConsulta);

                resultado[i] = PublicacaoResumo(
                    _dados.publicacao[_dados.identificacoesArtigosPublicacao[indiceInicial + i]].conteudo.titulo,
                    instituicoesValidadoraConsulta [0] != address(0)
                );
            }
        }      
    }
}