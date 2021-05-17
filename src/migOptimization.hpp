//
// Created by Julio 2021.05.
//

#include <iostream>
#include <mockturtle/algorithms/cut_enumeration.hpp>
#include <mockturtle/algorithms/mig_resub.hpp>
#include <mockturtle/algorithms/cleanup.hpp>
#include <mockturtle/algorithms/resubstitution.hpp>
#include <mockturtle/algorithms/akers_synthesis.hpp>
#include <mockturtle/networks/mig.hpp>
#include <alice/command.hpp>

#include "../include/mockturtle/algorithms/node_resynthesis/mig_npn.hpp"
#include "../include/mockturtle/algorithms/lut_mapping.hpp"

using namespace mockturtle;
using namespace std;

namespace alice{

//###########################################################################################
    class migCut_command : public command
    {
        public:
            explicit migCut_command( const environment::ptr& env )
            : command( env, "K-cuts Enumeration algorithm" )
        {
            opts.add_option( "-k, Kcut Size",k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
                auto env_mig {env->store<mig_t>()};
                    if(env_mig.empty()) {
                        env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the K-cuts." << std::endl;
                        return;
                }
                mig_t clone = store<mig_t>().current();
                mig_t mig(clone);
                cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";
                cut_enumeration_params ps;

                ps.cut_size = k;
                cout<<"o tamanho do k: "<<k<<"\n";
                ps.cut_limit = ps.cut_size;
                auto cuts = cut_enumeration<mig_network, true>(*mig, ps);
                cout<<"kcuts ok!\n";
                cout<<"total de kcuts do mig :"<<cuts.total_cuts()<<"\n";

                for(int node=0; node < (int) mig.get()->num_gates();node++){
                    cout<<cuts.cuts(mig.get()->index_to_node(node));
                }

        }

        private:
            int k;
    };

    ALICE_ADD_COMMAND(migCut,"Mig-commands");

//###########################################################################################

//###########################################################################################

    ALICE_COMMAND(migLut,"Mig-commands", "Mig Lut Mapping algorithm"){
        auto env_mig {env->store<mig_t>()};
			if(env_mig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Mig Lut Mapping." << std::endl;
				return;
		}

        mig_t clone = store<mig_t>().current();
        mig_t mig(clone);
        cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";

		mapping_view<mig_network, true> m_view{*mig};
        cout<<"mapping view ok!\n";
        cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";

		lut_mapping<mapping_view<mig_network, true>, true>(m_view);
        cout<<"lut mapping ok!\n";
        cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";

    }
//###########################################################################################


//###########################################################################################
    class migCutRewrite_command : public command
    {
        public:
            explicit migCutRewrite_command( const environment::ptr& env )
            : command( env, "Mig Cut-Rewrinting" )
        {
            opts.add_option( "-k, Kcut Size", k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
            auto env_mig {env->store<mig_t>()};
                if(env_mig.empty()) {
                    env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Cut-Rewrinting." << std::endl;
                    return;
            }
            mig_t clone = store<mig_t>().current();
            mig_t mig(clone);
            cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";
            akers_resynthesis<mig_network> resyn;
            cut_rewriting_params cutRewPs;
            cout<<"o tamanho do k: "<<k<<"\n";
            cutRewPs.cut_enumeration_ps.cut_size = k;
            cut_rewriting<mig_network>(*mig,resyn,cutRewPs);
            cout<<"cut rewriting ok"<<"\n";
            cout<<"total de nodos do mig: "<< mig.get()->size()<<"\n";;
            mig_network migClean = cleanup_dangling<mig_network>(*mig );
            cout<<"clean dangling nodes ok"<<"\n";
            //transformar o migclean em storage
            cout<<"total de nodos do mig: "<< migClean.size()<<"\n";
            mig_t migPtr = std::make_shared<mockturtle::mig_network>(migClean);
            env->store<mig_t>().extend() = migPtr;//tentando retornar o mig para os stores do alice
        }

        private:
            int k;
    };
    ALICE_ADD_COMMAND(migCutRewrite,"Mig-commands");

//###########################################################################################

//###########################################################################################
    ALICE_COMMAND(migAlg,"Mig-commands", "Mig Algebraic Rewrinting algorithm"){
        auto env_mig {env->store<mig_t>()};
			if(env_mig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Mig Algebraic Rewrinting." << std::endl;
				return;
		}
        mig_t clone = store<mig_t>().current();
        mig_t mig(clone);
        cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";
        using view_mig = depth_view<fanout_view<mig_network, true>>;
        view_mig depthViewMig{*mig};
        mig_algebraic_depth_rewriting_params psMig;
//        psMig.strategy=psMig.aggressive;
//        psMig.strategy=psMig.selective;
//        psMig.strategy=psMig.dfs;
		mig_algebraic_depth_rewriting<depth_view<fanout_view<mig_network, true>>>(depthViewMig,psMig);
        cout<<"mig algebraic rewriting ok"<<"\n";
        cout<<"total de nodos do mig: "<< mig.get()->size()<<"\n";;
        mig_network migClean = cleanup_dangling<mig_network>(*mig );
        cout<<"clean dangling nodes ok"<<"\n";
        //transformar o migclean em storage
        cout<<"total de nodos do mig: "<< migClean.size()<<"\n";
        mig_t migPtr = std::make_shared<mig_network>(migClean);
        env->store<mig_t>().extend() = migPtr;//tentando retornar o mig para os stores do alice
    }
//###########################################################################################

//###########################################################################################
    ALICE_COMMAND(migResub,"Mig-commands", "Mig Resubstitution algorithm"){
        auto env_mig {env->store<mig_t>()};
			if(env_mig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Mig Resubstitution." << std::endl;
				return;
		}
        mig_t clone = store<mig_t>().current();
        mig_t mig(clone);
        cout<< "numero de nodos do mig: "<<mig.get()->size()<<"\n";
        using view_mig = mockturtle::depth_view<mockturtle::fanout_view<mockturtle::mig_network>>;
        fanout_view<mockturtle::mig_network> fanout_viewMig{*mig};
      	view_mig resub_view{fanout_viewMig};
        resubstitution(resub_view);
		cout<<"mig resubstitution ok"<<"\n";
        cout<<"total de nodos do mig: "<< mig.get()->size()<<"\n";
        mig_network migClean = cleanup_dangling<mig_network>(*mig );
        cout<<"clean dangling nodes ok"<<"\n";
        //transformar o migclean em storage
        cout<<"total de nodos do mig: "<< migClean.size()<<"\n";
        mig_t migPtr = std::make_shared<mig_network>(migClean);
        env->store<mig_t>().extend() = migPtr;//tentando retornar o mig para os stores do alice
    }

//###########################################################################################

//###########################################################################################
    class migNode_command : public command
    {
        public:
            explicit migNode_command( const environment::ptr& env )
            : command( env, "Mig Node-Resynthesis" )
        {
            opts.add_option( "-k, Kcut Size", k, "K size for Kcuts" )->required();
        }

        protected:
        void execute()
        {
            auto env_mig {env->store<mig_t>()};
                if(env_mig.empty()) {
                    env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Mig Node-Resynthesis." << std::endl;
                    return;
            }
            mig_t clone = store<mig_t>().current();
            mig_t mig(clone);

            cout<<"total de nodos do mig: "<< mig.get()->size()<<"\n";
            cout<<"digite o tamanho do k a ser considerado:\n";
            mapping_view<mig_network, true> m_view{*mig};
            lut_mapping_params psLut;
            psLut.cut_enumeration_ps.cut_size = k;
            lut_mapping<mapping_view<mig_network, true>, true>( m_view, psLut );
            const auto klut = mockturtle::collapse_mapped_network<mockturtle::klut_network>( m_view );
            mig_npn_resynthesis resyn(k);
            mig_network migClean = node_resynthesis<mig_network>( *klut, resyn );
            cout<<"mig mig npn resynthesis ok"<<"\n";
            cout<<"total de nodos do mig: "<< migClean.size()<<"\n";
            mig_t migPtr = std::make_shared<mig_network>(migClean);
            env->store<mig_t>().extend() = migPtr;//tentando retornar o mig para os stores do alice
        }

        private:
            int k;
    };
    ALICE_ADD_COMMAND(migNode,"Mig-commands");
//###########################################################################################

//###########################################################################################

    ALICE_COMMAND(migRefac,"Mig-commands", "Mig Refatoring"){
        auto env_mig {env->store<mig_t>()};
			if(env_mig.empty()) {
				env->err() << "\033[1;31m * \033[0mYou must load a mig to execute the Mig Resubstitution." << std::endl;
				return;
		}
        mig_t clone = store<mig_t>().current();
        mig_t mig(clone);
        cout<<"total de nodos do mig: "<< mig.get()->size()<<"\n";
        /* node resynthesis */
        akers_resynthesis<mig_network> resyn;
        refactoring<mig_network>(*mig,resyn);
        cout<<"mig mig refactoring ok"<<"\n";
        mig_network migClean = cleanup_dangling<mig_network>(*mig );
        cout<<"clean dangling nodes ok"<<"\n";
        cout<<"total de nodos do mig: "<< migClean.size()<<"\n";
        mig_t migPtr = std::make_shared<mig_network>(migClean);
        env->store<mig_t>().extend() = migPtr;//tentando retornar o mig para os stores do alice
    }
//###########################################################################################

};

