createUrl() {
    LOCATION="${1}"
    URL="${2}"
    VAL="${3}"

    INTERNAL_URL="https://api-ipv4.us-or.viasat.io/api/v1/environments/icat/dns/internal/CNAME/io/viasat/icat/${URL}"
    EXTERNAL_URL="https://api-ipv4.us-or.viasat.io/api/v1/environments/icat/dns/external/CNAME/io/viasat/icat/${URL}"


    if [[ "$LOCATION" == "internal" ]]; then
        echo "Internal"
        echo $INTERNAL_URL
        curl -u rcallen $INTERNAL_URL -XPOST -d["${VAL}"]
    else
        echo "External"
        echo $EXTERNAL_URL
        curl -u rcallen $EXTERNAL_URL -XPOST -d["${VAL}"]
    fi
}

# OLD
# createUrl internal jenkins-new Jenki-LoadB-NBGAZA7JP9L3-634024719.us-west-2.elb.amazonaws.com
# NEW
createUrl internal jenkins-new Jenki-LoadB-S85IF9EBHMWI-130509357.us-west-2.elb.amazonaws.com

# createUrl internal prod/ts-usage/my-viasat myviasat-tsusage-prodlb-1139340000.us-west-2.elb.amazonaws.com

# createUrl prod/ts-usage/my-viasat/_78ea309d85a3346abf72ac966637e3c4 _93ef239047ab361c3748754f1aa30582.jddtvkljgg.acm-validations.aws.
# createUrl dev/ts-usage/my-viasat/_7480db8ed4b6afaac46e664a21298908 _d534c6c9b96cd89c3268d2ef5698e0b3.jddtvkljgg.acm-validations.aws.
# createUrl test/ts-usage/my-viasat/_69a805164f6884b293cbe2208779d3a5 _bfa97f178a11f6c28dde26ca91a717a1.jddtvkljgg.acm-validations.aws.
# createUrl preprod/ts-usage/my-viasat/_2a38340a1154ad18572885415fc1b516 _ccd2ac53ee363436c3522729a195dbc5.jddtvkljgg.acm-validations.aws.

