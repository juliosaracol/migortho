#include <iostream>
#include <mockturtle/algorithms/cut_enumeration.hpp>
#include <mockturtle/algorithms/mig_resub.hpp>
#include <mockturtle/algorithms/cleanup.hpp>
#include <mockturtle/algorithms/resubstitution.hpp>
#include <mockturtle/algorithms/akers_synthesis.hpp>
#include <mockturtle/networks/aig.hpp>

#include "../include/mockturtle/algorithms/node_resynthesis/akers.hpp"


using namespace mockturtle;
using namespace std;

namespace alice{

//###########################################################################################
    class aigCut_command : public command
    {
        public:
            explicit aigCut_command( const environment::ptr& env )
            : command( env, "K-cuts Enumeration algorithm" )
        {
            opts.add_option( "-k, Kcut Size",k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
            auto env_aig {env->store<aig_t>()};
                if(env_aig.empty()) {
                    env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the K-cuts." << std::endl;
                    return;
            }
            aig_t clone = store<aig_t>().current();
            aig_t aig(clone);

            cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";
            cut_enumeration_params ps;
            ps.cut_size = k;
            cout<<"digite o tamanho do k:"<<k<<"\n";
            ps.cut_limit = ps.cut_size;
            auto cuts = cut_enumeration<aig_network, true>(*aig, ps);
            cout<<"kcuts ok!\n";
            cout<<"total de kcuts do aig :"<<cuts.total_cuts()<<"\n";

            for(int node=0; node < (int) aig.get()->num_gates();node++){
                cout<<cuts.cuts(aig.get()->index_to_node(node));
            }
        }
        private:
            int k;
    };

    ALICE_ADD_COMMAND(aigCut,"Aig-commands");
//###########################################################################################


//###########################################################################################
    ALICE_COMMAND(aigLut,"Aig-commands", "Aig Lut Mapping algorithm"){
        auto env_aig {env->store<aig_t>()};
			if(env_aig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Aig Lut Mapping." << std::endl;
				return;
		}

        aig_t clone = store<aig_t>().current();
        aig_t aig(clone);
        cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";

		mapping_view<aig_network, true> m_view{*aig};
        cout<<"mapping view ok!\n";
        cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";

		lut_mapping<mapping_view<aig_network, true>, true>(m_view);
        cout<<"lut mapping ok!\n";
        cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";

    }
//###########################################################################################

//###########################################################################################
    class aigCutRewrite_command : public command
    {
        public:
            explicit aigCutRewrite_command( const environment::ptr& env )
            : command( env, "Aig Cut-Rewrinting")
        {
            opts.add_option( "-k, Kcut Size",k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
            auto env_aig {env->store<aig_t>()};
                if(env_aig.empty()) {
                    env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Cut-Rewrinting." << std::endl;
                    return;
            }
            aig_t clone = store<aig_t>().current();
            aig_t aig(clone);
            cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";
            akers_resynthesis<aig_network> resyn;
            cut_rewriting_params cutRewPs;
            cout<<"digite o tamanho do k:"<<k<<"\n";
            cutRewPs.cut_enumeration_ps.cut_size = k;
            cut_rewriting<aig_network>(*aig,resyn,cutRewPs);
            cout<<"cut rewriting ok"<<"\n";
            cout<<"total de nodos do aig: "<< aig.get()->size()<<"\n";;
            aig_network aigClean = cleanup_dangling<aig_network>(*aig );
            cout<<"clean dangling nodes ok"<<"\n";
            //transformar o aigclean em storage
            cout<<"total de nodos do aig: "<< aigClean.size()<<"\n";
            aig_t aigPtr = std::make_shared<aig_nt>( aigClean );
            env->store<aig_t>().extend() = aigPtr;//tentando retornar o aig para os stores do alice
        }
        private:
            int k;
    };

    ALICE_ADD_COMMAND(aigCutRewrite,"Aig-commands");
//###########################################################################################

//###########################################################################################
    ALICE_COMMAND(aigMigAlg,"Aig-commands", "Aig in Mig Algebraic Rewrinting algorithm"){
        auto env_aig {env->store<aig_t>()};
			if(env_aig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Aig Algebraic Rewrinting." << std::endl;
				return;
		}
        aig_t clone = store<aig_t>().current();
        aig_t aig(clone);
        cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";
        using view_aig = depth_view<fanout_view<aig_network, true>>;
        view_aig depthViewAig{*aig};
        mig_algebraic_depth_rewriting_params psAig;
		mig_algebraic_depth_rewriting<depth_view<fanout_view<aig_network, true>>>(depthViewAig,psAig);
        cout<<"mig algebraic rewriting ok"<<"\n";
        cout<<"total de nodos do aig: "<< aig.get()->size()<<"\n";;
        aig_network aigClean = cleanup_dangling<aig_network>(*aig );
        cout<<"clean dangling nodes ok"<<"\n";
        //transformar o aigclean em storage
        cout<<"total de nodos do aig: "<< aigClean.size()<<"\n";
        aig_t aigPtr = std::make_shared<aig_nt>(aigClean);
        env->store<aig_t>().extend() = aigPtr;//tentando retornar o aig para os stores do alice
    }
//###########################################################################################

//###########################################################################################
    ALICE_COMMAND(aigResub,"Aig-commands", "Aig Resubstitution algorithm"){
        auto env_aig {env->store<aig_t>()};
			if(env_aig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Aig Resubstitution." << std::endl;
				return;
		}
        aig_t clone = store<aig_t>().current();
        aig_t aig(clone);
        cout<< "numero de nodos do aig: "<<aig.get()->size()<<"\n";
        using view_aig = depth_view<fanout_view<aig_network>>;
        fanout_view<aig_network> fanout_viewAig{*aig};
      	view_aig resub_view{fanout_viewAig};
        resubstitution(resub_view);
		cout<<"aig resubstitution ok"<<"\n";
        cout<<"total de nodos do aig: "<< aig.get()->size()<<"\n";
        aig_network aigClean = cleanup_dangling<aig_network>(*aig );
        cout<<"clean dangling nodes ok"<<"\n";
        //transformar o aigclean em storage
        cout<<"total de nodos do aig: "<< aigClean.size()<<"\n";
        aig_t aigPtr = std::make_shared<aig_nt>(aigClean);
        env->store<aig_t>().extend() = aigPtr;//tentando retornar o aig para os stores do alice
    }
//###########################################################################################

//###########################################################################################
    class aigNode_command : public command
    {
        public:
            explicit aigNode_command( const environment::ptr& env )
            : command( env, "Aig Node-Resynthesis")
        {
            opts.add_option( "-k, Kcut Size",k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
            auto env_aig {env->store<aig_t>()};
                if(env_aig.empty()) {
                    env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Aig Resubstitution." << std::endl;
                    return;
            }
            aig_t clone = store<aig_t>().current();
            aig_t aig(clone);

            cout<<"total de nodos do aig: "<< aig.get()->size()<<"\n";
            cout<<"digite o tamanho do k:"<<k<<"\n";
            mapping_view<aig_network, true> m_view{*aig};
            lut_mapping_params psLut;
            psLut.cut_enumeration_ps.cut_size = k;
            lut_mapping<mapping_view<aig_network, true>, true>( m_view, psLut );
            const auto klut = mockturtle::collapse_mapped_network<mockturtle::klut_network>( m_view );
            akers_resynthesis<aig_network> resyn;
            aig_network aigClean = node_resynthesis<aig_network>(*klut, resyn );
            cout<<"aig aig npn resynthesis ok"<<"\n";
            cout<<"total de nodos do aig: "<< aigClean.size()<<"\n";
            aig_t aigPtr = std::make_shared<aig_nt>(aigClean);
            env->store<aig_t>().extend() = aigPtr;//tentando retornar o aig para os stores do alice
        }
        private:
            int k;
    };

    ALICE_ADD_COMMAND(aigNode,"Aig-commands");
//###########################################################################################

//###########################################################################################
    ALICE_COMMAND(aigRefac,"Aig-commands", "Aig Refatoring"){
        auto env_aig {env->store<aig_t>()};
			if(env_aig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a aig to execute the Aig Resubstitution." << std::endl;
				return;
		}
        aig_t clone = store<aig_t>().current();
        aig_t aig(clone);
        cout<<"total de nodos do aig: "<< aig.get()->size()<<"\n";
        /* node resynthesis */
        akers_resynthesis<aig_network> resyn;
        refactoring<aig_network>(*aig,resyn);
        cout<<"aig aig refactoring ok"<<"\n";
        aig_network aigClean = cleanup_dangling<aig_network>(*aig );
        cout<<"clean dangling nodes ok"<<"\n";
        cout<<"total de nodos do aig: "<< aigClean.size()<<"\n";
        aig_t aigPtr = std::make_shared<aig_nt>(aigClean);
        env->store<aig_t>().extend() = aigPtr;//tentando retornar o aig para os stores do alice
    }
//###########################################################################################

};

